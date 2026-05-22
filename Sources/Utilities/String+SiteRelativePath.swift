//
//  String+SiteRelativePath.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/19/25.
//

import Foundation

extension String {
    /// Strips the site's scheme + host from an absolute URL so `Image` resolves it
    /// against the local `Assets/` directory for `@2x` / `~dark` variants instead of
    /// treating the full URL as a file path (which triggers Ignite's "Could not read
    /// the assets directory" warning). Non-site URLs and already-relative paths pass through.
    var siteRelativeImagePath: String {
        guard let url = URL(string: self),
              url.host?.contains("ryantoken.com") == true
        else { return self }
        return url.path
    }
}
