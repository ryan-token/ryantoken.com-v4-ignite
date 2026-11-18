//
//  Badge.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/19/25.
//

import Ignite

/// A pill-shaped label, such as a post's tag. It links to `path` when given;
/// without one (e.g. the current tag in a tag page's title) it's plain text.
struct Badge: InlineElement {
    let name: String
    let size: Font.Style
    var path: String?

    var body: some InlineElement {
        // Type-erased so both branches share a type, as the builder requires.
        if let path {
            AnyInlineElement(Link(label, target: path).role(.none))
        } else {
            AnyInlineElement(label)
        }
    }

    private var label: some InlineElement {
        Span(name)
            .font(size)
            .fontWeight(.medium)
            .foregroundStyle(.primary)
            .background(.lightBlue.opacity(0.3))
            .padding(.horizontal, .em(0.75))
            .padding(.vertical, .em(0.4))
            .cornerRadius(6)
            .margin(.bottom, .em(0.25))
    }
}
