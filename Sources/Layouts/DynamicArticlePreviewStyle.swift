//
//  DynamicArticlePreviewStyle.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/19/25.
//

import Ignite

struct DynamicArticlePreviewStyle: @preconcurrency ArticlePreviewStyle {
    let cornerRadius = 16

    @MainActor func body(content: Article) -> any HTML {
        Section {
            mobileLayout(for: content)
                .class("d-block d-md-none")

            desktopLayout(for: content)
                .class("d-none d-md-flex")
        }
        .style(.backgroundColor, "var(--bs-secondary-bg, #f8fafc)")
        .cornerRadius(cornerRadius)
        .border(.gray.opacity(0.15), width: 1)
        .shadow(.black.opacity(0.1), radius: 6, x: 0, y: 4)
        .margin(.bottom, .em(1.5))
    }

    // MARK: - Layout Components

    @MainActor
    private func mobileLayout(for article: Article) -> some HTML {
        Section {
            VStack {
                if let image = article.image {
                    Link(
                        Image(image.siteRelativeImagePath, description: article.imageDescription)
                            .resizable()
                            .cornerRadius(cornerRadius)
                            .margin(.bottom, .em(0.5)),
                        target: article.path
                    )
                }

                articleContent(article, includesSpacer: false)
            }
        }
    }

    @MainActor
    private func desktopLayout(for article: Article) -> some HTML {
        Section {
            HStack(alignment: .top) {
                if let image = article.image {
                    Link(
                        Image(image.siteRelativeImagePath, description: article.imageDescription)
                            .resizable()
                            .frame(maxHeight: 180)
                            .cornerRadius(cornerRadius),
                        target: article.path
                    )
                }

                articleContent(article, includesSpacer: true)
                    .frame(minWidth: 0) // Allow text to wrap properly
            }
            .class("align-items-stretch") // Ensure equal height columns
        }
    }

    @MainActor
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
                    .class("d-flex flex-wrap gap-2") // Enable wrapping with gap
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
