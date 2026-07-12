//
//  DynamicArticlePreviewStyle.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/19/25.
//

import Ignite

struct DynamicArticlePreviewStyle: ArticlePreviewStyle {
    func body(content: Article) -> any HTML {
        Section {
            mobileLayout(for: content)
                .class("d-block d-md-none")

            desktopLayout(for: content)
                .class("d-none d-md-flex")
        }
        .margin(.bottom, .em(1.5))
    }

    // MARK: - Layouts

    /// Desktop: the full-height squircle icon sits flush in the card's left.
    /// The card's left corners are rounded past the icon (hidden behind it) so
    /// no background peeks through the squircle's transparent corners; the right
    /// corners match the icon's visible roundness. See `preview-desktop-card`.
    private func desktopLayout(for article: Article) -> some HTML {
        HStack(alignment: .top) {
            if let image = article.image {
                iconLink(for: article, image: image).class("preview-desktop-icon")
            }

            articleContent(article, includesSpacer: true)
                .frame(minWidth: 0) // Allow text to wrap properly
        }
        .class("align-items-stretch") // Equal-height columns so the icon fills the card
        .cardChrome()
        .class("preview-desktop-card")
    }

    /// Mobile: the full-width squircle icon caps the top of the card, with the
    /// body tucked underneath so the icon's curve becomes the card's top edge.
    private func mobileLayout(for article: Article) -> some HTML {
        Section {
            if let image = article.image {
                iconLink(for: article, image: image).class("preview-mobile-icon")
            }

            Section {
                articleContent(article, includesSpacer: false)
            }
            .cardChrome()
            .class("preview-mobile-body")
        }
        .class("preview-mobile")
    }

    // MARK: - Components

    /// The post's app icon, masked to a squircle and linked to the article.
    /// Sizing is layout-specific (see the `preview-*-icon` CSS classes).
    private func iconLink(for article: Article, image: String) -> some InlineElement {
        Link(
            Image(image.siteRelativeImagePath, description: article.imageDescription)
                .resizable()
                .class("app-icon"),
            target: article.path
        )
    }

    private func articleContent(_ article: Article, includesSpacer: Bool) -> some HTML {
        VStack(alignment: .leading) {
            Text {
                Link(article.title, target: article)
                    .role(.none)
                    .foregroundStyle(.body)
                    .padding(.bottom, 4)
                    .font(.title5)
                    .fontWeight(.semibold)
            }

            if let subtitle = article.subtitle {
                Text {
                    Link(subtitle, target: article)
                        .role(.none)
                        .foregroundStyle(.secondary)
                        .font(.title6)
                        .fontWeight(.regular)
                        .padding(.bottom, 4)
                        .lineSpacing(1.25)
                }
            }

            Text(markdown: "*\(article.date.formatted(date: .abbreviated, time: .omitted))*")
                .font(.title6)
                .fontWeight(.regular)
                .foregroundStyle(.secondary)

            // Tags - wrapped in Section to apply Bootstrap classes
            if let tags = article.tags, !tags.isEmpty {
                Section {
                    Section {
                        ForEach(tags) { tag in
                            Badge(name: TagFormatter.format(tag), size: .small, path: "/tags/\(tag)")
                        }
                    }
                    .class("d-flex flex-wrap gap-2 preview-tags") // Enable wrapping with gap
                    .padding(.top, 16)
                }
                .class(includesSpacer ? "mt-auto" : "")
            }
        }
        .padding(8)
        .padding(.horizontal, 24)
        .class(includesSpacer ? "d-flex flex-column h-100" : "") // Apply flexbox for desktop
    }
}

private extension HTML {
    /// The shared card surface: secondary background, hairline border, and a
    /// soft drop shadow. Corner radii are layout-specific (see the
    /// `preview-desktop-card` / `preview-mobile-body` CSS classes).
    func cardChrome() -> some HTML {
        self
            .style(.backgroundColor, "var(--bs-secondary-bg, #f8fafc)")
            .border(.gray.opacity(0.15), width: 1)
            .shadow(.black.opacity(0.1), radius: 6, x: 0, y: 4)
    }
}
