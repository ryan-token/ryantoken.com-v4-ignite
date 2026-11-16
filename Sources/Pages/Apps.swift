//
//  Apps.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/15/25.
//

import Ignite

struct Apps: StaticPage {
    var title = "Ryan Token - Apps"
    var description = "The apps Ryan makes for Apple platforms, including Daysheets, CatchUp: Keep in Touch, Outrank: CFB Stat Rankings, YouHQ: Life Organizer, Hot Local Food: Find Dinner, and Chat by Storyboard. All of them are written in Swift and SwiftUI."
    var image: URL? = URL(static: Constants.staticOutrankImagePath)

    var body: some HTML {
        HeaderText("Apps", size: .h2)
		SubheaderText("The apps I make. All of them are native, written with [Swift](\(Constants.swiftWebUrl)) and [SwiftUI](\(Constants.swiftUIWebUrl)).")

        Grid(alignment: .leading) {
            ImageWithLink(
                imagePath: "/images/daysheets/daysheets-logo.png",
                imageDescription: "Daysheets' app icon",
                imageType: .appIcon,
                url: Constants.daysheetsWebUrl
            )
            ImageWithLink(
                imagePath: "/images/catching-up/catchup-icon.png",
                imageDescription: "CatchUp's app icon",
                imageType: .appIcon,
                url: Constants.catchUpAppUrl
            )
            ImageWithLink(
                imagePath: "/images/outrank-v2/outrank-icon.png",
                imageDescription: "Outrank's app icon",
                imageType: .appIcon,
                url: Constants.outrankAppUrl
            )
            ImageWithLink(
                imagePath: "/images/youhq/youhq-icon.png",
                imageDescription: "YouHQ's app icon",
                imageType: .appIcon,
                url: Constants.youHQAppUrl
            )
            ImageWithLink(
                imagePath: "/images/hot-local-food/hlf-icon-square.png",
                imageDescription: "Hot Local Food's app icon",
                imageType: .appIcon,
                url: Constants.hotLocalFoodAppUrl
            )
            ImageWithLink(
                imagePath: "/images/storyboard/chat-app-icon.png",
                imageDescription: "Chat by Storyboard's app icon",
                imageType: .appIcon,
                url: Constants.storyboardAppUrl
            )
        }
        .margin(.vertical, -16)

        DividerWithMargin()

		VStack(alignment: .leading) {
            HeaderText("Daysheets", size: .h3)
            SubheaderText("(2025 - Present)")
        }

        ImageWithLink(
            imagePath: "/images/daysheets/daysheets-logo.png",
            imageDescription: "The app icon for Daysheets",
            imageType: .appIcon,
            url: Constants.daysheetsWebUrl
        )
        .frame(maxWidth: Constants.appIconMaxWidth)

		Text(markdown: "I work full-time as a lead software engineer for [Daysheets](\(Constants.daysheetsWebUrl)), the new standard for tour management.")

		Text(markdown: "I build the native Daysheets [iOS](\(Constants.daysheetsiOSUrl)) and [macOS](\(Constants.daysheetsMacUrl)) apps with Swift and SwiftUI to help tour managers and coordinators plan, operate, and collaborate on medium and large-scale music tours.")

        ImageWithLink(
            imagePath: "/images/daysheets/daysheets.webp",
            imageDescription: "Daysheets marketing image that shows the iOS and macOS apps.",
            url: Constants.daysheetsWebUrl
        )

        Text(markdown: "The iOS and macOS apps were developed for Daysheets, Inc. using Swift, SwiftUI, Core Data, and a Swift Package that encompasses shared functionality between platforms.")

        DividerWithMargin()

		VStack(alignment: .leading) {
            HeaderText("CatchUp: Keep in Touch", size: .h3)
            SubheaderText("(2018 - Present)")
        }

        ImageWithLink(
            imagePath: "/images/catching-up/catchup-icon.png",
            imageDescription: "The app icon for CatchUp: Keep in Touch",
            imageType: .appIcon,
            url: Constants.catchUpAppUrl
        )
        .frame(maxWidth: Constants.appIconMaxWidth)

        Text(markdown: "**Featured on Brett Terpstra's [Systematic](https://systematicpod.com/ep/218) Podcast as one of his 'Top 3' picks (around 46:21)*")
            .foregroundStyle(.secondary)

        Text(markdown: "My first public-facing iOS app! CatchUp helps you stay in touch with the people who matter most. You can set reminders for the contacts you choose, and get notified when it's time to CatchUp with them again.")

        Text(markdown: "CatchUp is free with no ads, but has an in-app tip jar if you want to buy me a coffee ☕")

        Grid(alignment: .leading) {
            ImageWithLink(
                imagePath: "/images/catchup-v3/next-catchups.png",
                imageDescription: "A screenshot of CatchUp's home screen",
                url: Constants.catchUpAppUrl
            )
            .frame(maxWidth: Constants.defaultImageMaxWidth)
            ImageWithLink(
                imagePath: "/images/catchup-v3/detail-screen.png",
                imageDescription: "A screenshot of CatchUp's detail screen",
                url: Constants.catchUpAppUrl
            )
            .frame(maxWidth: Constants.defaultImageMaxWidth)
			ImageWithLink(
				imagePath: "/images/catchup-v3/contact-search.png",
				imageDescription: "A screenshot of CatchUp's contact search screen",
				url: Constants.catchUpAppUrl
			)
			.frame(maxWidth: Constants.defaultImageMaxWidth)
        }

        Text(markdown: "Read my blog post about modernizing CatchUp with SwiftUI [here](/blog/catching-up) or my latest post about releasing version 3.0 with SwiftData and several new features [here](/blog/catchup-v3).")

        AppStoreBadge(url: Constants.catchUpAppUrl)

        DividerWithMargin()

		VStack(alignment: .leading) {
            HeaderText("Outrank: CFB Stat Rankings", size: .h3)
            SubheaderText("(2021 - Present)")
        }

        ImageWithLink(
            imagePath: "/images/outrank-v2/outrank-icon.png",
            imageDescription: "The app icon for Outrank: CFB Stat Rankings",
            imageType: .appIcon,
            url: Constants.outrankAppUrl
        )
        .frame(maxWidth: Constants.appIconMaxWidth)

        Text(markdown: "Outrank shows where your college football team ranks nationally in \(Constants.outrankStatCount) stats against all \(Constants.fbsTeamCount) FBS teams, with the real numbers behind every ranking.")

        Text(markdown: "Tap any stat to see every team ranked, compare two teams side by side ahead of a big matchup, or see how a team's ranking has moved day by day with History charts going back to \(Constants.outrankHistoryStartYear).")

        Grid {
            ImageWithLink(
                imagePath: "/images/outrank-v2/outrank-rankings.png",
                imageDescription: "Outrank's rankings screen",
                url: Constants.outrankAppUrl
            )
            ImageWithLink(
                imagePath: "/images/outrank-v2/outrank-history.png",
                imageDescription: "Outrank's history chart screen",
                url: Constants.outrankAppUrl
            )
            ImageWithLink(
                imagePath: "/images/outrank-v2/outrank-stat.png",
                imageDescription: "Outrank's stat rankings screen",
                url: Constants.outrankAppUrl
            )
            ImageWithLink(
                imagePath: "/images/outrank-v2/outrank-compare.png",
                imageDescription: "Outrank's compare screen",
                url: Constants.outrankAppUrl
            )
            ImageWithLink(
                imagePath: "/images/outrank-v2/outrank-widgets.png",
                imageDescription: "Outrank's Top Four and Bottom Four widgets",
                url: Constants.outrankAppUrl
            )
        }
        .margin(.bottom)

        Text(markdown: "Version 2.0 brings a fresh design, historical data charts, stat values, redesigned widgets, and a new backend that updates rankings faster and more often.")

        Text(markdown: "Outrank is free with no ads, and the History charts come with an optional subscription. You can read my original blog post about building it [here](/blog/introducing-outrank).")

        AppStoreBadge(url: Constants.outrankAppUrl)

        DividerWithMargin()

		VStack(alignment: .leading) {
            HeaderText("YouHQ: Life Organizer", size: .h3)
            SubheaderText("(2026 - Present)")
        }

        ImageWithLink(
            imagePath: "/images/youhq/youhq-icon.png",
            imageDescription: "The app icon for YouHQ: Life Organizer",
            imageType: .appIcon,
            url: Constants.youHQAppUrl
        )
        .frame(maxWidth: Constants.appIconMaxWidth)

        Text(markdown: "[YouHQ](\(Constants.youHQWebUrl)) is your life, organized. Track your homes, vehicles, finances, media, and career - all in one private, beautiful app.")

        Text(markdown: "YouHQ works natively across iPhone, iPad, Mac, and Apple Vision Pro, and is built with Swift, SwiftUI, and [SQLiteData](https://github.com/pointfreeco/sqlite-data).")

        Grid {
            ImageWithLink(
                imagePath: "/images/youhq/youhq-home.png",
                imageDescription: "YouHQ's home screen",
                url: Constants.youHQAppUrl
            )
            ImageWithLink(
                imagePath: "/images/youhq/youhq-vehicles.png",
                imageDescription: "YouHQ's vehicles screen",
                url: Constants.youHQAppUrl
            )
            ImageWithLink(
                imagePath: "/images/youhq/youhq-money.png",
                imageDescription: "YouHQ's money screen",
                url: Constants.youHQAppUrl
            )
            ImageWithLink(
                imagePath: "/images/youhq/youhq-media.png",
                imageDescription: "YouHQ's media screen",
                url: Constants.youHQAppUrl
            )
            ImageWithLink(
                imagePath: "/images/youhq/youhq-career.png",
                imageDescription: "YouHQ's career screen",
                url: Constants.youHQAppUrl
            )
        }
        .margin(.bottom)

        Text("Organize every part of your life:")
        List {
            "Homes: Track utilities, maintenance reminders, paint colors, and cost of ownership"
            "Vehicles: Track insurance, service reminders, and paint colors"
            "Money: Track bank, investment, and HSA/FSA accounts"
            "Media: Track service providers, subscriptions, and devices with total monthly cost"
            "Career: Track job history and salary trends over time"
			"Profiles: Manage your own data and/or someone else's, with optional iCloud sharing"
        }

        Text(markdown: "Your data is your own. Sensitive fields are encrypted on-device with AES-256-GCM encryption before they ever leave your device, and there are no YouHQ servers - everything syncs directly through iCloud via your Apple Account.")

		Text(markdown: "The source code for YouHQ is fully open source and available on [GitHub](https://github.com/ryan-token/YouHQ).")

		Text(markdown: "You can read the announcement blog post for YouHQ [here](/blog/introducing-youhq). Learn more about the app on [its website](\(Constants.youHQWebUrl)).")

        AppStoreBadge(url: Constants.youHQAppUrl)

        DividerWithMargin()

		VStack(alignment: .leading) {
            HeaderText("Hot Local Food: Find Dinner", size: .h3)
            SubheaderText("(2023 - Present)")
        }

        ImageWithLink(
            imagePath: "/images/hot-local-food/hlf-icon-square.png",
            imageDescription: "The app icon for Hot Local Food: Find Dinner",
            imageType: .appIcon,
            url: Constants.hotLocalFoodAppUrl
        )
        .frame(maxWidth: Constants.appIconMaxWidth)

        Text(markdown: "Think Tinder, but for food, and it already likes you back. Say hello to **Hot Local Food**. Free, hot, and available on iOS 15 and newer.")

        Text(markdown: "Want something to eat or drink but don't know where to go? Want to explore the local scene nearby or far away? Just want to look at some good pictures of good food? Hot Local Food is there for you.")

        Text(markdown: "With a photo-heavy, Tinder-style swipe interface, an extensive library of restaurants powered by [Yelp](https://fusion.yelp.com/), and slick features built on top, Hot Local Food will help you find exactly what you need.")

		Grid {
			ImageWithLink(
				imagePath: "/images/hot-local-food/hlf-home.png",
				imageDescription: "Hot Local Food's home screen",
				url: Constants.hotLocalFoodAppUrl
			)
			ImageWithLink(
				imagePath: "/images/hot-local-food/hlf-detail.png",
				imageDescription: "Hot Local Food's restaurant detail screen",
				url: Constants.hotLocalFoodAppUrl
			)
			ImageWithLink(
				imagePath: "/images/hot-local-food/hlf-location.png",
				imageDescription: "Hot Local Food's location screen",
				url: Constants.hotLocalFoodAppUrl
			)
			ImageWithLink(
				imagePath: "/images/hot-local-food/hlf-lists.png",
				imageDescription: "Hot Local Food's lists screen",
				url: Constants.hotLocalFoodAppUrl
			)
		}
		.margin(.bottom)

        Text("Features:")
        List {
            "When you’re out, see restaurants nearby and swipe until you find your perfect match"
            "Traveling somewhere? Get to know what’s good by swiping in the area you plan to visit"
            "Filter by price, location, and categories"
            "Create custom lists to save places for later"
            "Access quick shortcuts to make reservations, order delivery or pickup, and find directions"
        }

        Text(markdown: "For vegans, carnivores, and everyone in between, Hot Local Food is the best place to find what you love, so you can eat it.")

        Text(markdown: "You can follow Hot Local Food on [X](https://x.com/hotlocalfood), check out its [marketing website](\(Constants.hotLocalFoodMarketingUrl)), or read my [blog post](/blog/hot-local-food) about building it.")

        AppStoreBadge(url: Constants.hotLocalFoodAppUrl)

        DividerWithMargin()

		VStack(alignment: .leading) {
            HeaderText("Chat by Storyboard", size: .h3)
            SubheaderText("(2023 - 2025)")
        }

        ImageWithLink(
            imagePath: "/images/storyboard/chat-app-icon.png",
            imageDescription: "The app icon for Chat by Storyboard",
            imageType: .appIcon,
            url: Constants.storyboardAppUrl
        )
        .frame(maxWidth: Constants.appIconMaxWidth)

        Text(markdown: "[Chat by Storyboard](\(Constants.storyboardAppUrl)) is an AI-powered, hands-free voice messaging app for truckers. It’s a game-changer for the trucking industry, and I’m proud to have been a core part of its development.")

        Text(markdown: "I built the native iOS and iPadOS apps myself with Swift, SwiftUI, Swift Concurrency, Core Audio, App Intents, SQLite, and more.")

        AppStoreBadge(url: Constants.storyboardAppUrl)
    }
}
