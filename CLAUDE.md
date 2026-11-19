# ryantoken.com

Personal site, generated in Swift with [Ignite](https://github.com/Ignite-Swift/Ignite) and hosted on Vercel. The Ignite library the site builds against is the SwiftPM checkout at `.build/checkouts/Ignite` (pinned in `Package.resolved`); read it to confirm an API rather than guessing. The Homebrew `ignite` is only the CLI.

# Commands
- Build: `swift run` (writes the site to `Build/`)
- Preview: `ignite run` serves `Build/` at http://localhost:8000; `ignite run --preview` also opens a browser. Neither rebuilds, so run `swift run` first.
- Validate HTML: `vnu --skip-non-html Build` (Homebrew `vnu`)
- After adding or changing an image in `Assets/images`: `Scripts/optimize-images.sh`

# Conventions
- Keep the site's HTML and CSS as close to 100% standards-compliant as possible. Run `vnu` after changes; the only accepted messages are Ignite's "Trailing slash on void elements" info notes and the `sandbox` error on Apple's podcast embed (`Includes/hurricast-embed.html`), which keeps Apple's non-standard `allow-storage-access-by-user-activation` keyword on purpose.
- `Build/` is checked in: rebuild with `swift run` after any source, content, or CSS change so it stays in sync.
- Prefer Ignite modifiers and Bootstrap classes over custom CSS. Custom styles go in `Assets/css/custom.css`, using the theme's `--bs-*` variables (set in `Sources/Themes/Themes.swift`) so light and dark mode both work.

# Gotchas
- `Badge` is Ignite's component; the site's capsule label is `PillBadge`.
- The W3C CSS validator reports false errors for CSS nesting in `ignite-core.min.css` and for `line-clamp` in `custom.css`; both are valid.
