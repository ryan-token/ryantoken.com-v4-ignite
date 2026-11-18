//
//  ArticleLayout.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/14/25.
//

import Ignite

struct ArticleLayout: ArticlePage {
    var body: some HTML {
        VStack(alignment: .leading) {
            HeaderText(article.title)

            if let subtitle = article.subtitle {
                Text(markdown: "*\(subtitle)*")
                    .foregroundStyle(.secondary)
            }

            Text(markdown: "*Published \(article.date.postDateString)*")
                .foregroundStyle(.secondary)
                .padding(.top, 24)

            Text(markdown: "*\(article.estimatedWordCount) words; \(article.estimatedReadingMinutes) minutes to read.*")
                .foregroundStyle(.secondary)

            Divider()

            if let image = article.image {
                Image(image.siteRelativeImagePath, description: article.imageDescription)
                    .resizable()
                    // The page's largest above-the-fold image, so fetch it first.
                    .attribute("loading", "eager")
                    .attribute("fetchpriority", "high")
                    .cornerRadius(20)
                    .class("article-cover")
            }

            Section {
                Text(article.text)
            }
            .padding(.top, 36)
            .class("article-content")
        }
    }
}
