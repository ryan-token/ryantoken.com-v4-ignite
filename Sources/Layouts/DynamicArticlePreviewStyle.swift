//
//  DynamicArticlePreviewStyle.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/19/25.
//

import Ignite

/// A blog post preview card, rendered as a single responsive grid (see the
/// `preview-card` CSS):
/// - Mobile: a compact row with a small squircle icon beside the title,
///   subtitle, and date, and the tags across the full card width below.
/// - Desktop: the full-height icon sits flush in the card's left, with the
///   tags pinned to the bottom of the text column.
///
/// The whole card opens the post via a stretched link on the title (its
/// `::after` covers the card), while the tags sit above that overlay so they
/// still open their tag pages.
struct DynamicArticlePreviewStyle: ArticlePreviewStyle {
    /// The heading level of each post's title, one below the heading the list
    /// sits under: `h2` beneath a page's `h1`, or `.title3` beneath the home
    /// page's "Latest blog posts" `h2`. The visual size is the same at every level.
    var headingLevel: Font.Style = .title2

    func body(content article: Article) -> any HTML {
        Ignite.Tag("article") {
            if let image = article.image {
                // Decorative: the title right beside it already names the post.
                Image(decorative: image.siteRelativeImagePath.iconImagePath)
                    .resizable()
                    .class("app-icon", "preview-icon")
            }

            Section {
                Text {
                    Link(article.title, target: article)
                        .role(.none)
                        .foregroundStyle(.body)
                        .class("stretched-link")
                }
                .font(headingLevel)
                .fontWeight(.semibold)
                // Same visual size at every heading level.
                .class("fs-5", "preview-title")

                if let subtitle = article.subtitle {
                    Text(subtitle)
                        .foregroundStyle(.secondary)
                        .class("fs-6", "preview-subtitle")
                }

                Text {
                    Time(Emphasis(article.date.postDateString), dateTime: article.date)
                }
                .foregroundStyle(.secondary)
                .class("fs-6", "preview-date")
            }
            .class("preview-text")

            if let tags = article.tags, !tags.isEmpty {
                Section {
                    ForEach(tags) { tag in
                        PillBadge(name: TagFormatter.format(tag), size: .small, path: "/tags/\(tag)")
                    }
                }
                .class("preview-tags")
            }
        }
        .class("preview-card")
    }
}
