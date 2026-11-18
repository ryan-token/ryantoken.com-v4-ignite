//
//  ImageWithLink.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/18/25.
//

import Ignite

struct ImageWithLink: HTML {
    enum ImageType {
        /// Clipped to the Apple squircle, with a shadow that follows it.
        case appIcon
        /// A square-ish brand mark, drawn as-is.
        case logo
        /// A screenshot, button, or other content image.
        case generic
    }

    var imagePath: String
    var imageDescription: String
    var imageType: ImageType = .generic
    var url: String
    /// Load immediately rather than lazily, for images near the top of a page.
    var loadsEagerly = false

    private var isAppIcon: Bool { imageType == .appIcon }

    /// Icons and logos are drawn small, so they use the 512px copy, and float up
    /// on hover like the blog post preview cards (see `.hover-lift` in custom.css).
    private var isIconLike: Bool { imageType != .generic }

    var body: some HTML {
        Link(
            Image(isIconLike ? imagePath.iconImagePath : imagePath, description: imageDescription)
                .resizable()
                .cornerRadius(.percent(Percentage(isAppIcon ? 0 : 1)))
                .margin(.top, 4)
                .margin(.bottom, 16)
                .attribute("loading", loadsEagerly ? "eager" : "lazy")
                // App icons are clipped to the Apple "squircle" silhouette (see
                // custom.css) so every icon matches the YouHQ icon's shape.
                .class(isAppIcon ? "app-icon" : nil),
            target: url
        )
        // The squircle-aware drop-shadow and the hover lift live on the link so
        // they trace the masked icon rather than the rectangular image box.
        .class(isAppIcon ? "app-icon-link" : nil, isIconLike ? "hover-lift" : nil)
    }
}
