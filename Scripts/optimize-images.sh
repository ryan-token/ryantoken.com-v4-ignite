#!/usr/bin/env bash
#
# Generates the derived images the site serves, next to each original in
# Assets/images. Originals are never modified.
#
#   name-512.png / name-512.jpg   A 512px copy of every square image larger than
#                                 that (app icons, logos, post covers). Pages draw
#                                 these at 180px or less, so 512px stays sharp on
#                                 3x screens; the full-size original remains the
#                                 og:image for link previews.
#   name.webp                     A WebP copy of every PNG/JPEG (including the
#                                 512px copies), capped at 1600px wide: twice the
#                                 site's 770px content column. Kept only when it's
#                                 meaningfully smaller than the original.
#
# The build (ImagePostProcessor) serves a WebP through <picture> wherever one
# exists, with the original as the fallback for browsers without WebP support.
#
# Each original's SHA-256 is recorded in optimize-images.manifest (beside this
# script) once its copies are made. Only originals that are new or changed since
# then are processed, so rerunning is cheap and never rewrites committed copies.
# The build serves an image's copies only while its hash still matches (see
# OptimizedImages.swift). Content hashes are used rather than modification times
# because git doesn't preserve those.
#
# Run after adding or changing an image, and commit the manifest with the copies.
#
# Requires: cwebp and pngquant (brew install webp pngquant), plus macOS's sips
# and shasum.

set -euo pipefail
shopt -s nullglob

readonly SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly IMAGES_DIR="$(cd "$SCRIPTS_DIR/../Assets/images" && pwd)"
readonly MANIFEST="$SCRIPTS_DIR/optimize-images.manifest"
readonly ICON_SIZE=512
readonly MAX_WEBP_WIDTH=1600
readonly WEBP_QUALITY=82
# A WebP must be at least this much smaller than its original to be worth serving.
readonly MIN_SAVINGS_PERCENT=10
# Images referenced from CSS rather than <img>, so they're left as-is.
readonly EXCLUDED_IMAGES=("squircle-mask.png")
# JPEG/PNG fallbacks made by hand from a WebP original (paths relative to
# Assets/images). The WebP is the source here, so it's never regenerated.
readonly WEBP_ORIGINALS=("daysheets/daysheets.jpg")

for tool in cwebp pngquant sips shasum; do
    command -v "$tool" >/dev/null || { echo "error: $tool is not installed" >&2; exit 1; }
done

# Prints every original PNG/JPEG under IMAGES_DIR (not the 512px copies this
# script makes), NUL-separated, minus EXCLUDED_IMAGES.
source_images() {
    local exclusions=()
    for name in "${EXCLUDED_IMAGES[@]}"; do exclusions+=(! -name "$name"); done

    find "$IMAGES_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) \
        ! -name "*-$ICON_SIZE.*" "${exclusions[@]}" -print0 | sort -z
}

relative_path() { echo "${1#"$IMAGES_DIR"/}"; }
pixel_width() { sips -g pixelWidth "$1" | awk '/pixelWidth/ { print $2 }'; }
pixel_height() { sips -g pixelHeight "$1" | awk '/pixelHeight/ { print $2 }'; }
file_size() { stat -f %z "$1"; }
sha256() { shasum -a 256 "$1" | cut -d ' ' -f 1; }

is_webp_original() {
    local path
    path=$(relative_path "$1")
    for original in "${WEBP_ORIGINALS[@]}"; do [[ "$path" == "$original" ]] && return 0; done
    return 1
}

# Manifest lines are `<sha256>  <path relative to IMAGES_DIR>`, as shasum writes them.
is_recorded() { grep -qxF "$(sha256 "$1")  $(relative_path "$1")" "$MANIFEST"; }

forget() {
    local path
    path=$(relative_path "$1")
    awk -v path="$path" 'substr($0, 67) != path' "$MANIFEST" > "$MANIFEST.tmp"
    mv "$MANIFEST.tmp" "$MANIFEST"
}

record() {
    forget "$1"
    echo "$(sha256 "$1")  $(relative_path "$1")" >> "$MANIFEST"
}

# Writes a ICON_SIZE copy of a square image, palette-quantized like the originals.
make_icon_copy() {
    local source="$1" target="$2"

    sips --resampleWidth "$ICON_SIZE" "$source" --out "$target" >/dev/null
    if [[ "$target" == *.png ]]; then
        pngquant --force --skip-if-larger --strip --quality 70-95 --output "$target" -- "$target" || true
    fi
    echo "  icon  $(relative_path "$target")"
}

# Writes a WebP copy of an image, or removes it again if it doesn't save enough.
make_webp() {
    local source="$1"
    local target="${source%.*}.webp"
    local resize=()

    (( $(pixel_width "$source") > MAX_WEBP_WIDTH )) && resize=(-resize "$MAX_WEBP_WIDTH" 0)

    # sharp_yuv keeps text and edges in screenshots crisp; alpha stays lossless.
    cwebp -quiet -q "$WEBP_QUALITY" -m 6 -sharp_yuv -alpha_q 100 -metadata icc \
        "${resize[@]}" "$source" -o "$target"

    local original webp
    original=$(file_size "$source")
    webp=$(file_size "$target")

    if (( webp * 100 > original * (100 - MIN_SAVINGS_PERCENT) )); then
        rm "$target"
        echo "  skip  $(relative_path "$source") (WebP saves too little)"
    else
        echo "  webp  $(relative_path "$target") ($(( original / 1024 ))KB -> $(( webp / 1024 ))KB)"
    fi
}

echo "Optimizing images in $IMAGES_DIR"
touch "$MANIFEST"

# Forget originals that no longer exist.
while IFS= read -r line; do
    [[ -e "$IMAGES_DIR/${line:66}" ]] || forget "$IMAGES_DIR/${line:66}"
done < <(cat "$MANIFEST")

while IFS= read -r -d '' image; do
    is_recorded "$image" && continue

    # 1. A 512px copy (and its WebP) for a large square image; otherwise drop any
    #    copy left over from an earlier version of the image.
    icon="${image%.*}-$ICON_SIZE.${image##*.}"
    width=$(pixel_width "$image")
    if (( width > ICON_SIZE && width == $(pixel_height "$image") )); then
        make_icon_copy "$image" "$icon"
        make_webp "$icon"
        record "$icon"
    elif [[ -e "$icon" ]]; then
        rm -f "$icon" "${icon%.*}.webp"
        forget "$icon"
    fi

    # 2. A WebP copy of the original.
    is_webp_original "$image" || make_webp "$image"

    record "$image"
done < <(source_images)

LC_ALL=C sort -k 2 -o "$MANIFEST" "$MANIFEST"
echo "Done."
