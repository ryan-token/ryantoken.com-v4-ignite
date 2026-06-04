//
//  ArticleMarkdownRenderer.swift
//  RyanToken.com
//
//  Created by Ryan Token on 6/3/26.
//

import Ignite

/// A Markdown renderer that keeps every heading, including the first one.
///
/// Ignite's default `MarkdownToHTML` treats the first heading in a post as the
/// document title, and `Article` always parses articles with
/// `removeTitleFromBody: true`, which deletes that first heading from the
/// rendered body entirely. Because we always supply the title via front matter
/// (`title:`), that stripping doesn't replace anything; it just silently drops
/// each post's first `##` heading.
///
/// This renderer wraps `MarkdownToHTML` but ignores the incoming flag and never
/// strips the title, so leading headings render like any other heading. The
/// front-matter `title:` still wins for the page title (see `Article.resolveTitle`).
struct ArticleMarkdownRenderer: ArticleRenderer {
    private let parser: MarkdownToHTML

    var title: String { parser.title }
    var description: String { parser.description }
    var body: String { parser.body }
    var removeTitleFromBody: Bool { false }

    init(markdown: String, removeTitleFromBody: Bool) {
        // Deliberately ignore `removeTitleFromBody` so the first heading is kept.
        parser = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)
    }
}
