//
//  HeaderText.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/15/25.
//

import Ignite

struct HeaderText: HTML {
    enum Size {
        case h1, h2, h3, h4, h5, h6
    }

    let text: String
    let size: Size
    /// When set, the header becomes a linkable section (e.g. `/apps#outrank`) with a
    /// link icon that appears on hover and copies the section's URL (see anchors.js).
    let anchor: String?

    init(_ text: String, size: Size = .h1, anchor: String? = nil) {
        self.text = text
        self.size = size
        self.anchor = anchor
    }

    var titleSize: Font.Style {
        switch size {
        case .h1:
            .title1
        case .h2:
            .title2
        case .h3:
            .title3
        case .h4:
            .title4
        case .h5:
            .title5
        case .h6:
            .title6
        }
    }

    var style: ForegroundStyle {
        switch size {
        case .h1:
                .primary
        case .h2:
                .body
        case .h3:
                .body
        case .h4:
                .secondary
        case .h5:
                .body
        case .h6:
                .body
        }
    }

    var body: some HTML {
        if let anchor {
            styled(Text {
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
            })
            .id(anchor)
            .class("section-anchor", "anchor-heading")
            // Name the heading by its title alone, so screen readers don't also read
            // out the copy-link button's label when navigating by heading.
            .attribute("aria-labelledby", "\(anchor)-title")
        } else {
            styled(Text(markdown: text))
        }
    }

    private func styled(_ header: Text) -> some HTML {
        header
            .font(titleSize)
            .fontWeight(.semibold)
            .foregroundStyle(style)
            .lineSpacing(1)
    }
}
