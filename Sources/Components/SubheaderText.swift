//
//  SubheaderText.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/16/25.
//

import Ignite

struct SubheaderText: HTML {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    /// A subtitle, not a section heading, so it renders as a paragraph rather
    /// than an `h5`. The theme's `h5` and body sizes match (18px), so only the
    /// heading's tighter bottom margin needs carrying over.
    var body: some HTML {
        Text(markdown: "*\(text)*")
            .foregroundStyle(.secondary)
            .lineSpacing(1.5)
            .margin(.bottom, .rem(0.5))
    }
}
