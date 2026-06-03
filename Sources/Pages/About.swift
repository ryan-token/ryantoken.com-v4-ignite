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

        Image("/images/me/profile-2025.jpeg", description: "A picture of Ryan Token with a mountain ridge backdrop.")
            .resizable()
            .cornerRadius(16)
            .frame(maxWidth: Constants.defaultImageMaxWidth)
            .margin(.top, 4)
            .margin(.bottom, 16)

        Text(markdown: "Hi, I'm Ryan. You can find me writing [code](https://github.com/ryan-token), running my [podcast](\(Constants.hurricastWebUrl)), or watching my [team](https://tulsahurricane.com/).")

        Text(markdown: "My side projects include [Serverless Swift](/blog/serverless-swift), [YouHQ](\(Constants.youHQAppUrl)), [CatchUp](\(Constants.catchUpAppUrl)), and [The Golden Hurricast](\(Constants.hurricastWebUrl)).")

        Grid {
            ImageWithLink(
                imagePath: "/images/serverless-swift/serverless-swift.png",
                imageDescription: "Blog post cover image for my Serverless Swift project",
                imageType: .appIcon,
                url: "/blog/serverless-swift"
            )
            ImageWithLink(
                imagePath: "/images/youhq/youhq-icon.png",
                imageDescription: "YouHQ's app icon",
                imageType: .appIcon,
                url: Constants.youHQAppUrl
            )
            ImageWithLink(
                imagePath: "/images/catching-up/catchup-icon.png",
                imageDescription: "CatchUp's app icon",
                imageType: .appIcon,
                url: Constants.catchUpAppUrl
            )
            ImageWithLink(
                imagePath: "/images/hurricast/hurricast-icon.jpg",
                imageDescription: "The Golden Hurricast icon",
                imageType: .appIcon,
                url: Constants.hurricastWebUrl
            )
        }

        Text(markdown: "I'm currently deep into native Apple platform development (iOS and macOS), serverless web development, podcasting, and blogging.")

		Text(markdown: "My favorite programming language is [Swift](\(Constants.swiftWebUrl)), I tend to run my projects on [AWS](https://aws.amazon.com/), and I'm always looking to learn something new.")

        Text(markdown: "I'm also a die-hard fan of the [Tulsa Golden Hurricane](https://tulsahurricane.com) and college sports in general.")
    }
}
