//
//  HeaderText.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/15/25.
//

import Ignite

/// A page or section heading.
///
/// The semantic level and the visual size are deliberately separate, following
/// Bootstrap's `.h1`–`.h6` classes: each page has exactly one `h1` (its title),
/// sections are `h2`s, and each is drawn one size smaller so the page title
/// never outweighs the "Ryan Token" brand in the navigation bar.
struct HeaderText: HTML {
    enum Level {
        /// The page's title: an `h1`, drawn at `h2` size.
        case page
        /// A section within the page: an `h2`, drawn at `h3` size.
        case section

        var element: Font.Style {
            switch self {
            case .page: .title1
            case .section: .title2
            }
        }

        var sizeClass: String {
            switch self {
            case .page: "h2"
            case .section: "h3"
            }
        }
    }

    let text: String
    let level: Level
    /// When set, the header becomes a linkable section (e.g. `/apps#outrank`) with a
    /// link icon that appears on hover and copies the section's URL (see anchors.js).
    let anchor: String?

    init(_ text: String, level: Level = .page, anchor: String? = nil) {
        self.text = text
        self.level = level
        self.anchor = anchor
    }

    var body: some HTML {
        if let anchor {
            Text {
                Span(text)
                    .id("\(anchor)-title")
                Link(target: "#\(anchor)") {
                    // The link's aria-label describes it, so the icon itself is hidden.
                    Image(systemName: "link-45deg", description: "")
                        .attribute("aria-hidden", "true")
                }
                .class("anchor-link")
                .attribute("aria-label", "Copy link to \(text)")
                .attribute("title", "Copy link")
            }
            .heading(level)
            .id(anchor)
            .class("section-anchor", "anchor-heading")
            // Name the heading by its title alone, so screen readers don't also read
            // out the copy-link button's label when navigating by heading.
            .attribute("aria-labelledby", "\(anchor)-title")
        } else {
            Text(markdown: text)
                .heading(level)
        }
    }
}

extension Text {
    /// Styles the text as a page or section heading: the level's element, drawn
    /// one size smaller (see `HeaderText`). For headings with more than plain text
    /// in them, such as the tag page's title badge.
    func heading(_ level: HeaderText.Level) -> some HTML {
        font(level.element)
            .class(level.sizeClass)
            .fontWeight(.semibold)
            .foregroundStyle(.body)
            .lineSpacing(1)
    }
}
