//
//  Meta.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/15/25.
//

import Ignite

struct Meta: StaticPage {
    var title = "Ryan Token - Meta"
    var description = "This website is built with Swift and Ignite. It's hosted on Vercel. The source code is available on GitHub."
    var image: URL? = URL(static: Constants.staticIgniteImagePath)

    var body: some HTML {
        HeaderText("Meta", size: .h2)
        SubheaderText("How this site was built.")

        ImageWithLink(imagePath: "/images/ignite.png", imageDescription: "The Ignite logo.", url: "https://github.com/twostraws/Ignite")
            .frame(maxWidth: Constants.appIconMaxWidth)

        IgniteAttribution()
            .margin(.bottom, -12)

        Text(markdown: "It's hosted on [Vercel](https://vercel.com), and the source code is on [GitHub](https://github.com/ryan-token/ryantoken.com-v4-ignite).")

        Text(markdown: "My favorite code editors are [Xcode](https://developer.apple.com/xcode/) (yes, really) and [Nova](https://nova.app/).")

        Text(markdown: "Previous versions of the site were built with [Svelte](https://svelte.dev/), [Tailwind](https://tailwindcss.com), [Publish](https://github.com/johnsundell/publish), [Netlify](https://www.netlify.com), and others.")
    }
}
