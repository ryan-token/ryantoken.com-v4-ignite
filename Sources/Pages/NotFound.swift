//
//  NotFound.swift
//  RyanToken.com
//

import Ignite

/// Rendered to `Build/404.html`, which Vercel serves for any path that doesn't exist.
/// Without this, Vercel serves its own generic error page.
struct NotFound: ErrorPage {
    var title = "Page Not Found"
    var description = "That page doesn't exist. Head back to the homepage or browse the blog."

    var body: some HTML {
        HeaderText("Page not found", size: .h2)
            .padding(.bottom, 4)

        Text("Sorry, there's nothing at this address. It may have moved, or the link that brought you here may be out of date.")
			.padding(.bottom)

        Badge(name: "Go Home", size: .title5, path: "/")
            .class("pill-badge")
            .padding(.top)

        Badge(name: "All Blog Posts", size: .title5, path: "/blog")
            .class("pill-badge")
            .padding(.top)
    }
}
