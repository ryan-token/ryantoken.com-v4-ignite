//
//  Date+PostDate.swift
//  RyanToken.com
//

import Foundation

extension Date {
    /// A post's publish date for display, e.g. "Nov 16, 2026".
    ///
    /// Ignite parses front-matter dates as UTC (and emits them that way in
    /// `<time datetime>`), so format in UTC too. Otherwise the visible day could
    /// differ from the machine-readable one depending on the build machine's
    /// time zone.
    var postDateString: String {
        formatted(Date.FormatStyle(date: .abbreviated, time: .omitted, timeZone: .gmt))
    }
}
