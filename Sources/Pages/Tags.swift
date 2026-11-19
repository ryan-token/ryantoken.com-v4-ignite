//
//  Tags.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/19/25.
//

import Ignite

struct Tags: TagPage {
    var sortedArticlesForTag: [Article] {
        tag.articles.sorted(by: \.date).reversed()
    }

    var body: some HTML {
        Text {
            // The trailing space keeps the heading's text "…tagged App" for screen
            // readers and search; the flex layout trims it visually (see custom.css).
            "Blog posts tagged "
            PillBadge(name: TagFormatter.format(tag.name), size: .title4)
        }
        .heading(.page)
        .class("tag-page-title")
        .padding(.bottom)

        ForEach(sortedArticlesForTag) { article in
            ArticlePreview(for: article)
                .articlePreviewStyle(DynamicArticlePreviewStyle())
        }
    }
}
