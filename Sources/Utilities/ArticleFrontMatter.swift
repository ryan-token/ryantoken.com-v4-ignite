//
//  ArticleFrontMatter.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/28/26.
//

import Foundation

/// The Markdown front matter for every article, read straight from `Content` and
/// loaded once per build.
///
/// Ignite parses this same front matter, but its `Article.lastModified` silently falls
/// back to the `.md` file's filesystem timestamp when no modification date is declared.
/// That timestamp reflects when the file was last touched on disk — a 2020 post reads as
/// modified in 2025, when it wads migrated into this repo — so it isn't safe to publish as
/// a freshness signal. Reading the front matter directly keeps declared dates and
/// filesystem noise apart. `SEOPostProcessor` also runs after `publish()` returns, where
/// Ignite's parsed articles are no longer reachable.
struct ArticleFrontMatter {
    /// The article's site path without a leading slash, e.g. `blog/introducing-youhq`.
    let path: String

    /// The publication date, from the required `date:` key.
    let date: Date

    /// The last substantive edit, set only when a post declares `modified:` or
    /// `lastModified:`. Left `nil` otherwise rather than guessed at.
    let modified: Date?

    /// Raw front-matter tags, not the slugs Ignite derives from them.
    let tags: [String]

    /// The most recent date this article claims.
    var freshness: Date { modified ?? date }

    /// Every published article on the site.
    static let all: [ArticleFrontMatter] = load()

    static func article(atPath path: String) -> ArticleFrontMatter? {
        all.first { $0.path == path.trimmingPrefix("/") }
    }
}

// MARK: - Loading

private extension ArticleFrontMatter {
    static func load() -> [ArticleFrontMatter] {
        guard let contentDirectory = try? PackageDirectory.url().appending(path: "Content"),
              let files = FileManager.default.enumerator(at: contentDirectory, includingPropertiesForKeys: nil)
        else { return [] }

        return files.compactMap { file in
            guard let file = file as? URL, file.pathExtension == "md",
                  let contents = try? String(contentsOf: file, encoding: .utf8)
            else { return nil }

            let frontMatter = parse(contents)

            guard frontMatter["published"] != "false",
                  let date = frontMatter["date"].flatMap(date(from:))
            else { return nil }

            let path = file.deletingPathExtension()
                .path
                .trimmingPrefix(contentDirectory.path)
                .trimmingPrefix("/")

            let tags = (frontMatter["tags"] ?? "")
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { $0.isEmpty == false }

            return ArticleFrontMatter(
                path: String(path),
                date: date,
                modified: (frontMatter["modified"] ?? frontMatter["lastModified"]).flatMap(date(from:)),
                tags: tags)
        }
    }

    /// Pulls `key: value` pairs out of the leading `---` fenced block.
    static func parse(_ markdown: String) -> [String: String] {
        let lines = markdown.split(separator: "\n", omittingEmptySubsequences: false)
        guard lines.first?.trimmingCharacters(in: .whitespaces) == "---" else { return [:] }

        var frontMatter: [String: String] = [:]

        for line in lines.dropFirst() {
            if line.trimmingCharacters(in: .whitespaces) == "---" { break }
            guard let separator = line.firstIndex(of: ":") else { continue }
            let key = line[..<separator].trimmingCharacters(in: .whitespaces)
            let value = line[line.index(after: separator)...].trimmingCharacters(in: .whitespaces)
            frontMatter[key] = value
        }

        return frontMatter
    }

    /// Read as GMT to match the site's `timeZone`.
    static func date(from string: String) -> Date? {
        formatters.lazy.compactMap { $0.date(from: string) }.first
    }

    static let formatters: [DateFormatter] = ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "yyyy-MM-dd"]
        .map { format in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = .gmt
            formatter.dateFormat = format
            return formatter
        }
}
