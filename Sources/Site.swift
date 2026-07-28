//
//  Site.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/14/25.
//

import Foundation
import Ignite

@main
struct IgniteWebsite {
    static func main() async {
        var site = RyanTokenSite()

        do {
            try await site.publish()
            try SEOPostProcessor.run(site: site)
        } catch {
            // Build/ is committed as-is to deploy, so a half-written directory must not
            // look like a successful build.
            FileHandle.standardError.write(Data("\(error.localizedDescription)\n".utf8))
            exit(1)
        }
    }
}

struct RyanTokenSite: Site {
    var name = "Ryan Token"
    var url = URL(static: "https://www.ryantoken.com")
    var builtInIconsEnabled = true

    // Also used as the RSS channel description.
    var description: String? = "Ryan Token builds apps for Apple platforms, co-hosts The Golden Hurricast, and writes about Swift, SwiftUI, and cloud services."

    var author = "Ryan Token"

    var homePage = Home()
    var tagPage = Tags()
    var errorPage = NotFound()

    var layout = MainLayout()
    var lightTheme: (any Theme)? = LightTheme()
    var darkTheme: (any Theme)? = DarkTheme()

    // Use a renderer that keeps each post's first heading instead of stripping
    // it as the document title. See ArticleMarkdownRenderer for details.
    var articleRenderer: ArticleMarkdownRenderer.Type { ArticleMarkdownRenderer.self }

    var feedConfiguration = FeedConfiguration(mode: .full, contentCount: 1000, path: "/feed.rss")
    var syntaxHighlighterConfiguration: SyntaxHighlighterConfiguration = .init(languages: [.swift, .javaScript, .yaml, .css, .bash, .git, .sql])

    var favicon: URL? { URL(static: "/favicon/favicon.ico") }

    // `homePage` already publishes Home() at "/". Listing it here as well emitted a
    // byte-identical copy at "/home" with its own canonical tag.
    var staticPages: [any StaticPage] {
        About()
        Apps()
        Blog()
        Meta()
        PrivacyPolicy()
        Projects()
        TermsOfUse()
    }

    var articlePages: [any ArticlePage] {
        ArticleLayout()
    }
}
