//
//  String+IconImagePath.swift
//  RyanToken.com
//

import Foundation

extension String {
    /// The 512px copy of a square image (`/images/x/icon.png` →
    /// `/images/x/icon-512.png`), made by `Scripts/optimize-images.sh`.
    ///
    /// Icons, logos, and post covers are drawn at 180px or less, so the copy is
    /// sharp on 3x screens at a fraction of the original's size. The original stays
    /// the `og:image` for link previews. Falls back to the original when there's no
    /// current copy (images already 512px or smaller, or ones changed since the
    /// script last ran; see `OptimizedImages`).
    var iconImagePath: String {
        OptimizedImages.current.iconCopy(of: self) ?? self
    }
}
