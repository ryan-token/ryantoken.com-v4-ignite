import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some Document {
        Head {
            MetaLink(href: "/favicon/apple-touch-icon.png", rel: "apple-touch-icon")
                .customAttribute(name: "sizes", value: "180x180")
            MetaLink(href: "/css/custom.css", rel: "stylesheet")
        }
        
        Body {
            NavBar()
            content
                .padding(.top, 60)
                .padding(.horizontal, 10)
            Footer()
        }
        .padding(.vertical, .em(1))
        .padding(.horizontal, .em(0.25))
    }
}
