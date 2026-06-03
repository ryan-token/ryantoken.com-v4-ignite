//
//  ImageWithLink.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/18/25.
//

import Ignite

struct ImageWithLink: HTML {
    enum ImageType {
        case appIcon, generic
    }

    var imagePath: String
    var imageDescription: String
    var imageType: ImageType = .generic
    var url: String

    private var isAppIcon: Bool { imageType == .appIcon }

    var body: some HTML {
        Link(
            Image(imagePath, description: imageDescription)
                .resizable()
                .cornerRadius(.percent(Percentage(isAppIcon ? 0 : 1)))
                .margin(.top, 4)
                .margin(.bottom, 16)
                // App icons are clipped to the Apple "squircle" silhouette (see
                // custom.css) so every icon matches the YouHQ icon's shape.
                .class(isAppIcon ? "app-icon" : ""),
            target: url
        )
        // The squircle-aware drop-shadow lives on the link so it traces the
        // masked icon rather than the rectangular image box.
        .class(isAppIcon ? "app-icon-link" : "")
    }
}
