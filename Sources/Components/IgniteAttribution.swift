//
//  IgniteAttribution.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/15/25.
//

import Ignite

struct IgniteAttribution: HTML {
    var body: some HTML {
        Text {
            "This site was written in "
			Link("Swift", target: Constants.swiftWebUrl)
            " with "
            Link(
                Image("/images/ignite.png", description: "The Ignite logo.")
                    .resizable()
                    .frame(maxWidth: 50)
                    .padding(.bottom, 4),
                target: "https://github.com/twostraws/Ignite"
            )
            .target(.blank)
        }
    }
}
