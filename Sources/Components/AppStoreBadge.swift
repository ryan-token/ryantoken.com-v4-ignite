//
//  AppStoreBadge.swift
//  RyanToken.com
//
//  Created by Ryan Token on 6/3/26.
//

import Ignite

/// Apple's official "Download on the App Store" badge, linking to an app's
/// App Store product page. Uses the unmodified badge SVG shipped in Assets,
/// matching the badge used on the YouHQ marketing site.
struct AppStoreBadge: HTML {
    var url: String

    var body: some HTML {
        Link(
            Image("/images/app-store-badge.svg", description: "Download on the App Store")
                .resizable()
                .frame(width: 250),
            target: url
        )
    }
}
