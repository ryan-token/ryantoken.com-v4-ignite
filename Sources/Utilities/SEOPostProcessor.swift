//
//  SEOPostProcessor.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/28/26.
//

import Foundation
import Ignite

/// Corrections applied to the `Build` directory after `site.publish()` finishes.
///
/// Ignite writes canonical URLs without a trailing slash (`/blog/post`) but writes
/// internal links and sitemap entries with one, so Google fetches a URL whose canonical
/// tag disagrees with it and declines to index. The RSS feed already uses the slash-free
/// form; everything here normalizes onto that, and fills in metadata Ignite doesn't
/// generate: sitemap `<lastmod>` dates, and per-tag titles and descriptions (Ignite
/// hardcodes every tag page to "Tags").
///
/// The HTML rewrites are no-ops if the markup they look for is absent, so an upstream
/// Ignite change degrades to unprocessed output. `rewriteSiteMap` rebuilds rather than
/// patches, so it verifies it understood the input before overwriting.
enum SEOPostProcessor {
    static func run(site: some Site) throws {
        let buildDirectory = try PackageDirectory.url().appending(path: "Build")
        let articles = ArticleFrontMatter.all

        try normalizeInternalLinks(in: buildDirectory)
        try rewriteTagPageMetadata(in: buildDirectory, siteName: site.name)
        try rewriteErrorPage(in: buildDirectory)
        try rewriteSiteMap(in: buildDirectory, siteURL: site.url, articles: articles)

        print("SEO post-processing complete (\(articles.count) articles).")
    }
}

// MARK: - Internal links

private extension SEOPostProcessor {
    /// Only site-relative paths are touched: the pattern requires a leading `/` followed
    /// by a non-`/` character, so `href="/"` and absolute URLs are left alone. Asset
    /// links (`/css/…`, `/feed.rss`) never end in a slash, so they don't match.
    static var trailingSlashLink: Regex<(Substring, Substring)> { /href="(\/[^"\/][^"]*)\/"/ }

    /// Rewrites `href="/blog/post/"` to `href="/blog/post"` across every generated page,
    /// so internal links point at the same URL the canonical tag names.
    static func normalizeInternalLinks(in buildDirectory: URL) throws {
        try rewriteHTMLFiles(in: buildDirectory) { html in
            // Ignite escapes < and > inside code samples but leaves quotes intact, so an
            // href in a post's code block is indistinguishable from a real link. Skipping
            // <pre> keeps published samples byte-identical to what was written.
            html.replacingOutsideTag("pre") { segment in
                String(segment.replacing(trailingSlashLink) { #"href="\#($0.1)""# })
            }
        }
    }
}

// MARK: - Tag pages

private extension SEOPostProcessor {
    /// Gives every tag page a title and description of its own.
    ///
    /// Ignite hardcodes `title: "Tags"` / `description: "Tags"` for all of them, so every
    /// tag page ships identical metadata — which is why Google crawled `/tags/ios` and
    /// declined to index it. The `TagPage` protocol exposes no hook for this, and the
    /// alternative (disabling Ignite's standard headers to hand-roll the whole `<head>`)
    /// would mean reimplementing framework-internal helpers.
    static func rewriteTagPageMetadata(in buildDirectory: URL, siteName: String) throws {
        let tagsDirectory = buildDirectory.appending(path: "tags")

        // The all-tags page lists every article, making it a near-duplicate of /blog. It
        // isn't linked from the navigation and Google was already skipping it, so it's
        // kept out of search results. Individual tag pages stay indexable, reachable from
        // the tag badges on every article preview.
        try rewriteMetadata(
            in: tagsDirectory.appending(path: "index.html"),
            title: "Blog Tags - \(siteName)",
            description: "Browse every blog post Ryan Token has written, by topic.")
        try excludeFromSearchResults(tagsDirectory.appending(path: "index.html"))

        let tagDirectories = (try? FileManager.default.contentsOfDirectory(at: tagsDirectory, includingPropertiesForKeys: nil)) ?? []

        for directory in tagDirectories where directory.hasDirectoryPath {
            let name = TagFormatter.format(directory.lastPathComponent)

            try rewriteMetadata(
                in: directory.appending(path: "index.html"),
                title: "\(name) - \(siteName)",
                description: "Every blog post Ryan Token has written about \(name), newest first.")
        }
    }

    /// Replaces the placeholder title and description Ignite gave a tag page, across the
    /// document title and the Open Graph and Twitter cards.
    static func rewriteMetadata(in page: URL, title: String, description: String) throws {
        try rewrite(page) { html in
            html
                .replacingOccurrences(of: "<title>Tags</title>", with: "<title>\(title)</title>")
                .replacingOccurrences(of: #"property="og:title" content="Tags""#, with: #"property="og:title" content="\#(title)""#)
                .replacingOccurrences(of: #"name="twitter:title" content="Tags""#, with: #"name="twitter:title" content="\#(title)""#)
                .replacingOccurrences(of: #"name="description" content="Tags""#, with: #"name="description" content="\#(description)""#)
                .replacingOccurrences(of: #"property="og:description" content="Tags""#, with: #"property="og:description" content="\#(description)""#)
                .replacingOccurrences(of: #"name="twitter:description" content="Tags""#, with: #"name="twitter:description" content="\#(description)""#)
        }
    }

    /// Adds `noindex, follow` to a page that shouldn't appear in search results but whose
    /// outbound links should still be crawled.
    static func excludeFromSearchResults(_ page: URL) throws {
        try rewrite(page) { html in
            guard html.contains(#"name="robots""#) == false else { return html }
            return html.replacingOccurrences(
                of: "</title>",
                with: #"</title><meta name="robots" content="noindex, follow" />"#)
        }
    }
}

// MARK: - Error page

private extension SEOPostProcessor {
    /// Ignite renders the error page with the site root as its URL, so it inherits the
    /// homepage's canonical tag and `og:url`. Paired with `noindex` that's a contradiction
    /// — it points search engines at `/` while telling them not to index this document —
    /// and `cleanUrls` makes `/404` reachable at a 200 status, so both matter.
    static func rewriteErrorPage(in buildDirectory: URL) throws {
        let page = buildDirectory.appending(path: "404.html")

        try rewrite(page) { html in
            html
                .replacing(/<link href="[^"]*" rel="canonical" \/>/, with: "")
                .replacing(/<meta property="og:url" content="[^"]*" \/>/, with: "")
        }

        try excludeFromSearchResults(page)
    }
}

// MARK: - Sitemap

private extension SEOPostProcessor {
    /// Ignite's generated entry, with the `<lastmod>` this step adds treated as optional
    /// so a rerun over already-processed output still parses every URL.
    static var siteMapEntry: Regex<(Substring, Substring, Substring)> {
        /<url><loc>([^<]+)<\/loc>(?:<lastmod>[^<]*<\/lastmod>)?<priority>([^<]+)<\/priority><\/url>/
    }

    /// Rebuilds `sitemap.xml`, dropping the trailing slashes so every `<loc>` matches its
    /// page's canonical tag, removing `/tags`, and adding `<lastmod>` where a date follows
    /// from article dates.
    ///
    /// `<lastmod>` is a crawl-scheduling signal Google discounts when it looks invented,
    /// so it's emitted only for posts and the listings that surface them. It's optional,
    /// so static pages get none.
    static func rewriteSiteMap(in buildDirectory: URL, siteURL: URL, articles: [ArticleFrontMatter]) throws {
        let siteMap = buildDirectory.appending(path: "sitemap.xml")
        guard let generated = try? String(contentsOf: siteMap, encoding: .utf8) else { return }

        let matches = generated.matches(of: siteMapEntry)

        // Overwriting on a partial parse would silently ship a truncated sitemap.
        guard matches.count == generated.components(separatedBy: "<url>").count - 1 else {
            throw SEOPostProcessorError.unrecognizedSiteMapFormat
        }

        let newestArticleDate = articles.map(\.freshness).max()

        let entries = matches.compactMap { match -> String? in
            let location = withoutTrailingSlash(String(match.1))
            let path = location.trimmingPrefix(siteURL.absoluteString)

            guard path != "/tags" else { return nil }

            let lastModified: Date? = switch path {
            case "", "/", "/blog": newestArticleDate
            case _ where path.hasPrefix("/tags/"):
                articles
                    .filter { $0.tags.contains(String(path.dropFirst("/tags/".count))) }
                    .map(\.freshness)
                    .max()
            default:
                articles.first { "/" + $0.path == path }?.freshness
            }

            return urlElement(location: location, lastModified: lastModified, priority: String(match.2))
        }

        let siteMapXML = """
        <?xml version="1.0" encoding="UTF-8"?>
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
        \(entries.joined(separator: "\n"))
        </urlset>
        """

        try siteMapXML.write(to: siteMap, atomically: true, encoding: .utf8)
    }

    static func urlElement(location: String, lastModified: Date?, priority: String) -> String {
        let lastMod = lastModified.map { "<lastmod>\($0.formatted(.iso8601.year().month().day()))</lastmod>" } ?? ""
        return "  <url><loc>\(location)</loc>\(lastMod)<priority>\(priority)</priority></url>"
    }

    /// Strips the trailing slash Ignite's `SiteMapGenerator` appends, leaving the site
    /// root alone since it has no slash-free equivalent.
    static func withoutTrailingSlash(_ location: String) -> String {
        guard location.hasSuffix("/"), URL(string: location)?.path != "/" else { return location }
        return String(location.dropLast())
    }
}

// MARK: - File helpers

private extension SEOPostProcessor {
    static func rewriteHTMLFiles(in directory: URL, transform: (String) -> String) throws {
        guard let files = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil) else { return }

        for case let file as URL in files where file.pathExtension == "html" {
            try rewrite(file, transform: transform)
        }
    }

    static func rewrite(_ file: URL, transform: (String) throws -> String) throws {
        guard let contents = try? String(contentsOf: file, encoding: .utf8) else { return }
        let updated = try transform(contents)
        guard updated != contents else { return }
        try updated.write(to: file, atomically: true, encoding: .utf8)
    }
}

private extension String {
    /// Applies `transform` to everything outside `<tag>…</tag>` regions, leaving their
    /// contents untouched.
    func replacingOutsideTag(_ tag: String, _ transform: (Substring) -> String) -> String {
        var result = ""
        var remainder = self[...]

        while let open = remainder.range(of: "<\(tag)") {
            result += transform(remainder[..<open.lowerBound])

            guard let close = remainder.range(of: "</\(tag)>", range: open.upperBound..<remainder.endIndex) else {
                return result + remainder[open.lowerBound...]
            }

            result += remainder[open.lowerBound..<close.upperBound]
            remainder = remainder[close.upperBound...]
        }

        return result + transform(remainder)
    }
}

enum SEOPostProcessorError: LocalizedError {
    case unrecognizedSiteMapFormat

    var errorDescription: String? {
        switch self {
        case .unrecognizedSiteMapFormat:
            "Ignite's sitemap.xml no longer matches the expected format; SEOPostProcessor.siteMapEntry needs updating."
        }
    }
}
