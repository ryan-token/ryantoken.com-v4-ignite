//
//  Blog.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/15/25.
//

import Ignite

struct Blog: StaticPage {
    @Environment(\.articles) var articles

    var title = "Ryan Token - Blog"
    var description = "All of Ryan's blog posts. He writes about Swift, SwiftUI, cloud services, and more."
    var image: URL? = URL(static: Constants.staticProfileImagePath)

    var sortedArticles: [Article] {
        articles.all.sorted(by: \.date).reversed()
    }

    var body: some HTML {
        HeaderText("Blog")
        SubheaderText("All blog posts. Subscribe to my [RSS feed](/feed.rss).")
            .padding(.bottom)

        ForEach(sortedArticles) { article in
            ArticlePreview(for: article)
                .articlePreviewStyle(DynamicArticlePreviewStyle())
        }
    }
}
