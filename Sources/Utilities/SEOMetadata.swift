//
//  SEOMetadata.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/28/26.
//

import Foundation
import Ignite

/// Builds the schema.org JSON-LD `MainLayout` injects into article and home pages.
enum SEOMetadata {
    static func blogPosting(for article: Article, page: PageMetadata, site: SiteMetadata, author: String) -> String {
        let url = page.url.absoluteString

        var json: [String: Any] = [
            "@context": "https://schema.org",
            "@type": "BlogPosting",
            "headline": article.title,
            "url": url,
            "mainEntityOfPage": ["@type": "WebPage", "@id": url],
            "datePublished": timestamp(article.date),
            "author": personObject(site: site, name: article.author ?? author),
            "publisher": personObject(site: site, name: author),
            "inLanguage": "en-US"
        ]

        if article.description.isEmpty == false {
            json["description"] = article.description
        }

        if let modified = modifiedDate(for: article) {
            json["dateModified"] = timestamp(modified)
        }

        if let image = article.image {
            json["image"] = absolute(image, site: site)
        }

        if let tags = article.tags, tags.isEmpty == false {
            json["keywords"] = tags.map(TagFormatter.format).joined(separator: ", ")
        }

        if article.estimatedWordCount > 0 {
            json["wordCount"] = article.estimatedWordCount
        }

        return encode(json)
    }

    static func website(site: SiteMetadata, author: String) -> String {
        var json: [String: Any] = [
            "@context": "https://schema.org",
            "@type": "WebSite",
            "name": site.name,
            "url": site.url.absoluteString,
            "inLanguage": "en-US",
            "author": personObject(site: site, name: author)
        ]

        if let description = site.description {
            json["description"] = description
        }

        return encode(json)
    }

    /// The standalone Person entity for the home page, as opposed to the abbreviated node
    /// embedded as an article's author or publisher.
    static func person(site: SiteMetadata, author: String) -> String {
        var json = personObject(site: site, name: author)
        json["@context"] = "https://schema.org"
        json["jobTitle"] = "Software Engineer"
        json["image"] = Constants.staticProfileImagePath.description
        json["sameAs"] = [
            Constants.githubUrl,
            Constants.xUrl,
            Constants.blueskyUrl,
            Constants.mastodonUrl,
            Constants.linkedInUrl
        ]
        return encode(json)
    }

    /// The date a post declares it was last revised, or `nil` if it never says.
    ///
    /// Deliberately not `article.lastModified`, which falls back to the `.md` file's
    /// filesystem timestamp — that changes whenever the file is touched and reads as a
    /// recent edit for posts written years ago.
    static func modifiedDate(for article: Article) -> Date? {
        ArticleFrontMatter.article(atPath: article.path)?.modified
    }

    /// The ISO 8601 form schema.org and Open Graph expect.
    static func timestamp(_ date: Date) -> String {
        date.formatted(.iso8601)
    }
}

private extension SEOMetadata {
    static func personObject(site: SiteMetadata, name: String) -> [String: Any] {
        [
            "@type": "Person",
            "name": name,
            "url": site.url.absoluteString
        ]
    }

    /// Search engines want absolute image URLs; front matter may declare either form.
    static func absolute(_ path: String, site: SiteMetadata) -> String {
        path.hasPrefix("http") ? path : site.url.appending(path: path).absoluteString
    }

    /// Sorted keys keep an unchanged page byte-identical across builds. `</` would
    /// otherwise close the enclosing `<script>` early.
    static func encode(_ json: [String: Any]) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: [.sortedKeys]),
              let string = String(data: data, encoding: .utf8)
        else {
            assertionFailure("Structured data contained a value JSONSerialization can't encode.")
            return "{}"
        }

        return string.replacingOccurrences(of: "</", with: "<\\/")
    }
}
