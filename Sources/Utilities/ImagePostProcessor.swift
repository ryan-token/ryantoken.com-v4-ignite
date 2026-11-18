//
//  ImagePostProcessor.swift
//  RyanToken.com
//

import Foundation
import ImageIO

/// Upgrades every site image in the generated HTML, wherever it came from: Swift
/// pages, Markdown images, or raw `<img>` tags inside posts. For each `<img>` whose
/// `src` is under `/images/`:
///
/// - **WebP**: when `Scripts/optimize-images.sh` made a current, smaller `.webp`
///   of the original (see `OptimizedImages`), the image is wrapped in a `<picture>` that offers the WebP and
///   keeps the original as the `<img>` fallback, so browsers without WebP support
///   still get the PNG/JPEG.
/// - **Intrinsic size**: `width`/`height` are set from the file, so the browser
///   reserves the right space before the image arrives (no layout shift). They
///   match the image's natural size, so they don't change how it renders.
/// - **Lazy loading**: `loading="lazy"` is added unless the source already chose a
///   loading mode. Images near the top of a page opt out with `loading="eager"`.
///
/// Images inside `<pre>` (code samples) and existing `<picture>` elements are left
/// as written.
enum ImagePostProcessor {
    static func run() throws {
        let buildDirectory = try BuildOutput.directory()
        let optimizedImages = OptimizedImages.current
        var dimensions = DimensionCache()

        if !optimizedImages.outdated.isEmpty {
            print("""
            ⚠️ These images changed since Scripts/optimize-images.sh last ran, so they're \
            served unoptimized. Run the script to update their WebP and 512px copies:
            \(optimizedImages.outdated.map { "  \($0)" }.joined(separator: "\n"))
            """)
        }

        try BuildOutput.rewriteHTMLFiles(in: buildDirectory) { html in
            html.replacingOutsideTag("pre") { segment in
                String(segment).replacingOutsideTag("picture") { segment in
                    String(segment.replacing(imageTag) { match in
                        upgradedImage(
                            String(match.output),
                            in: buildDirectory,
                            optimizedImages: optimizedImages,
                            dimensions: &dimensions
                        )
                    })
                }
            }
        }

        print("Image post-processing complete.")
    }
}

private extension ImagePostProcessor {
    static var imageTag: Regex<Substring> { /<img\b[^>]*>/ }
    static var sourceAttribute: Regex<(Substring, Substring)> { /\ssrc="(\/images\/[^"]+)"/ }

    static func upgradedImage(
        _ tag: String,
        in buildDirectory: URL,
        optimizedImages: OptimizedImages,
        dimensions: inout DimensionCache
    ) -> String {
        guard let path = tag.firstMatch(of: sourceAttribute).map({ String($0.1) }) else { return tag }

        let file = buildDirectory.appending(path: path)
        var attributes: [String] = []

        if !tag.hasAttribute("width"), !tag.hasAttribute("height"), let size = dimensions.size(of: file) {
            attributes += [#"width="\#(size.width)""#, #"height="\#(size.height)""#]
        }

        if !tag.hasAttribute("loading") {
            attributes.append(#"loading="lazy""#)
        }

        let image = tag.addingAttributes(attributes)

        guard let webpPath = optimizedImages.webpCopy(of: path) else { return image }

        return #"<picture><source srcset="\#(webpPath)" type="image/webp">\#(image)</picture>"#
    }
}

private extension String {
    func hasAttribute(_ name: String) -> Bool {
        contains(" \(name)=")
    }

    /// Inserts attributes before the tag's closing `>` or `/>`.
    func addingAttributes(_ attributes: [String]) -> String {
        guard !attributes.isEmpty else { return self }

        let closing = hasSuffix("/>") ? " />" : ">"
        let body = dropLast(closing == " />" ? 2 : 1).trimmingCharacters(in: .whitespaces)
        return "\(body) \(attributes.joined(separator: " "))\(closing)"
    }
}

/// Reads each image's pixel size once, however many pages show it.
private struct DimensionCache {
    struct Size {
        let width: Int
        let height: Int
    }

    private var sizes: [URL: Size?] = [:]

    mutating func size(of file: URL) -> Size? {
        if let cached = sizes[file] { return cached }

        let size = Self.readSize(of: file)
        sizes[file] = size
        return size
    }

    private static func readSize(of file: URL) -> Size? {
        guard let source = CGImageSourceCreateWithURL(file as CFURL, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? Int,
              let height = properties[kCGImagePropertyPixelHeight] as? Int
        else { return nil }

        return Size(width: width, height: height)
    }
}
