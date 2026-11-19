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
            "Blog posts tagged "
            PillBadge(name: TagFormatter.format(tag.name), size: .title4)
        }
        .heading(.page)
        .padding(.bottom)

        ForEach(sortedArticlesForTag) { article in
            ArticlePreview(for: article)
                .articlePreviewStyle(DynamicArticlePreviewStyle())
        }
    }
}
