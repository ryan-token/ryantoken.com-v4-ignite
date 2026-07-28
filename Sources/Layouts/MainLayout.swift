//
//  MainLayout.swift
//  RyanToken.com
//

import Foundation
import Ignite

struct MainLayout: Layout {
    @Environment(\.articles) private var articles
    @Environment(\.page) private var page
    @Environment(\.author) private var author
    @Environment(\.site) private var site

    var body: some Document {
        Head {
            MetaLink(href: "/favicon/apple-touch-icon.png", rel: "apple-touch-icon")
                .customAttribute(name: "sizes", value: "180x180")
            MetaLink(href: "/css/custom.css", rel: "stylesheet")

            // Ignite emits the Open Graph title, description and image, but no og:type,
            // publication metadata or structured data.
            if let article = currentArticle {
                MetaTag(property: "og:type", content: "article")
                MetaTag(property: "article:published_time", content: SEOMetadata.timestamp(article.date))

                if let modified = SEOMetadata.modifiedDate(for: article) {
                    MetaTag(property: "article:modified_time", content: SEOMetadata.timestamp(modified))
                }

                if author.isEmpty == false {
                    MetaTag(property: "article:author", content: author)
                }

                for tag in article.tags ?? [] {
                    MetaTag(property: "article:tag", content: TagFormatter.format(tag))
                }

                jsonLD(SEOMetadata.blogPosting(for: article, page: page, site: site, author: author))
            } else {
                MetaTag(property: "og:type", content: "website")
            }

            if isHomePage {
                jsonLD(SEOMetadata.website(site: site, author: author))
                jsonLD(SEOMetadata.person(site: site, author: author))
            }
        }

        Body {
            NavBar()
            content
                .padding(.top, 60)
                .padding(.horizontal, 10)
            Footer()
        }
        .padding(.vertical, .em(1))
        .padding(.horizontal, .em(0.25))
    }

    /// Ignite gives the home page a trailing slash and the error page the bare site URL,
    /// so matching on an empty path would claim the 404 page is the site's home page too.
    private var isHomePage: Bool {
        pagePath == "/"
    }

    /// The article this page is rendering, if it's a blog post.
    ///
    /// `EnvironmentValues.article` is internal to Ignite, so the article is matched by
    /// path instead — `PageMetadata.url` is built from the very same `article.path`.
    private var currentArticle: Article? {
        guard pagePath != "/" else { return nil }
        return articles.all.first { $0.path.trimmingPrefix("/") == pagePath.trimmingPrefix("/") }
    }

    /// Decoded, because `Article.path` isn't percent-encoded.
    private var pagePath: String {
        page.url.path(percentEncoded: false)
    }

    private func jsonLD(_ json: String) -> some HeadElement {
        Script(code: json).type(value: "application/ld+json")
    }
}
