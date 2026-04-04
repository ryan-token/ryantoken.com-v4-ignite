//
//  About.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/14/25.
//

import Ignite

struct About: StaticPage {
    var title = "Ryan Token - About"
    var description = "Ryan builds apps for Apple platforms, runs The Golden Hurricast, and writes about Swift, SwiftUI, cloud services, and more."
    var image: URL? = URL(static: Constants.staticProfileImagePath)

    var body: some HTML {
        HeaderText("About Me", size: .h2)
        SubheaderText("A bit about me.")
        SocialsBar()
            .padding(.bottom, 4)

        Image("/images/me/profile-2025.jpeg", description: "A picture of Ryan Token sitting in the back of a car.")
            .resizable()
            .cornerRadius(16)
            .frame(maxWidth: Constants.defaultImageMaxWidth)
            .margin(.top, 4)
            .margin(.bottom, 16)

        Text(markdown: "Hi, I'm Ryan. You can find me writing [code](https://github.com/ryan-token), running my [podcast](\(Constants.hurricastWebUrl)), or watching my [team](https://tulsahurricane.com/).")

        Text(markdown: "My latest projects include [Serverless Swift](/blog/serverless-swift), [CatchUp](\(Constants.catchUpAppUrl)), [Outrank](\(Constants.outrankAppUrl)), and [The Golden Hurricast](\(Constants.hurricastWebUrl)).")

        Grid {
            ImageWithLink(
                imagePath: "/images/serverless-swift/serverless-swift.png",
                imageDescription: "Blog post cover image for my Serverless Swift project",
                imageType: .appIcon,
                url: "/blog/serverless-swift"
            )
            ImageWithLink(
                imagePath: "/images/catching-up/catchup-icon.png",
                imageDescription: "CatchUp's app icon",
                imageType: .appIcon,
                url: Constants.catchUpAppUrl
            )
            ImageWithLink(
                imagePath: "/images/outrank/outrank-icon.png",
                imageDescription: "Outrank's app icon",
                imageType: .appIcon,
                url: Constants.outrankAppUrl
            )
            ImageWithLink(
                imagePath: "/images/hurricast/hurricast-icon.jpg",
                imageDescription: "The Golden Hurricast icon",
                imageType: .appIcon,
                url: Constants.hurricastWebUrl
            )
        }

        Text(markdown: "I'm currently deep into native Apple platform development (iOS and macOS), serverless web development, podcasting, and blogging.")

        Text(markdown: "My favorite programming language is [Swift](https://www.swift.org/), I tend to run my projects on [AWS](https://aws.amazon.com/), and I'm always looking to learn something new.")

        Text(markdown: "I'm also a die-hard fan of the [Tulsa Golden Hurricane](https://tulsahurricane.com) and college sports in general.")
    }
}
