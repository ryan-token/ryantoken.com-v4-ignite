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
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct RyanTokenSite: Site {
    var name = "Ryan Token"
    var url = URL(static: "https://www.ryantoken.com")
    var builtInIconsEnabled = true

    var author = "Ryan Token"

    var homePage = Home()
    var tagPage = Tags()

    var layout = MainLayout()
    var lightTheme: (any Theme)? = LightTheme()
    var darkTheme: (any Theme)? = DarkTheme()

    // Use a renderer that keeps each post's first heading instead of stripping
    // it as the document title. See ArticleMarkdownRenderer for details.
    var articleRenderer: ArticleMarkdownRenderer.Type { ArticleMarkdownRenderer.self }

    var feedConfiguration = FeedConfiguration(mode: .full, contentCount: 1000, path: "/feed.rss")
    var syntaxHighlighterConfiguration: SyntaxHighlighterConfiguration = .init(languages: [.swift, .javaScript, .yaml, .css, .bash, .git, .sql])

    var favicon: URL? { URL(static: "/favicon/favicon.ico") }

    var staticPages: [any StaticPage] {
        About()
        Apps()
        Blog()
        Home()
        Meta()
        PrivacyPolicy()
        Projects()
        TermsOfUse()
    }

    var articlePages: [any ArticlePage] {
        ArticleLayout()
    }
}
