---
author: Ryan Token
title: Swift Everywhere: Web Edition
subtitle: I have once again rewritten my website in Swift.
date: 2025-07-23 12:00
tags: swift, web, rewrite
published: true
image: https://www.ryantoken.com/images/ignite-padded.png
alt: The Ignite logo with a dark background
---

I've got a fever, and the only prescription is rewriting my website in Swift ([again](/blog/rebuilding-my-website)).

This is the first, or maybe [second](/blog/serverless-swift), in what I'm hoping will be a recurring series of posts about writing Swift for non-Apple platforms.

As I wrote in [A New Day(sheets) Dawns](/blog/a-new-day-dawns), I am fully on board for the vision of **Swift everywhere**. Swift on [iOS](https://www.swift.org/getting-started/swiftui/), Swift on [Android](https://www.swift.org/android-workgroup/), Swift on [Windows](https://www.swift.org/blog/swift-everywhere-windows-interop/), Swift in the [cloud](https://www.swift.org/get-started/cloud-services/), Swift on the [command line](https://www.swift.org/get-started/command-line-tools/)... You get the idea.

One of my favorite projects, and thus favorite posts, is about running [Swift on AWS Lambda](/blog/serverless-swift) to flash my Hue lightbulbs various colors whenever my favorite teams score or win. If I were to rename that post today, I'd consider it the first in this series and call it *Swift Everywhere: Serverless Edition*.

This post, however, is all about **Swift for the web**.

## Blank for some reason

## Inspiration

The inspiration to rebuild my website with Swift came from two primary sources:
1. [Paul Hudson](https://x.com/twostraws) launched [Ignite](https://github.com/twostraws/Ignite) - a static site generator for Swift developers
2. David Heinemeier Hansson's (aka DHH) [six-hour podcast](https://lexfridman.com/dhh-david-heinemeier-hansson/) with Lex Fridman

### Paul launches Ignite

I wrote an early version of my website in Swift using [Publish](https://github.com/JohnSundell/Publish) by John Sundell. While I loved the concept, I never quite found my footing with it. So when I saw that Paul had released Ignite, I was thrilled.

Ignite is essentially a modern take on Publish (down to the exact same 'About' description on GitHub), but with a SwiftUI-like syntax powered by Swift's [result builders](https://www.hackingwithswift.com/swift/5.4/result-builders). It also implements [Bootstrap](https://getbootstrap.com) to handle issues with browser and device compatibility, complex UI elements, and accessibility. I watched the [how and why video](https://www.youtube.com/watch?v=JJGLoo3A2uk) behind Ignite, read J.P. Toro's [Lighting Ignite on Fire](https://jptoro.dev/lighting-ignite-on-fire/) post, and was hooked. I built the CLI tool, ran `ignite new ExampleSite`, and got going.

However, I hit a bit of a false start. I looked at my [current/previous site](https://ryantoken-v3-svelte.vercel.app/) and thought, "I actually really like this, why go through the effort of a rewrite?" That, plus a barrage of work and life events, had me hitting the pause button.

### The Search for Code Poetry

It wasn't until I listened to the aforementioned Lex Fridman podcast featuring DHH a few months later that inspiration struck again - this time for good.

In particular, one specific concept stuck with me above all others from that six-hour interview: the idea that "writing code could feel as good as writing a poem" ([2:12:27](https://youtu.be/vagyIcmIGOQ?si=kL8L7XOrsPNrfg8W&t=7947)). In the era of prompt engineering and handing over large swaths of work to an AI assistant, this rang so true to me. Let me be clear: I use AI for my work every day. I find it completely invaluable. But I've also found that handing over *too much* of my work to AI is so much less satisfying than "chiseling beautiful code poems out of the editor" ([2:39:17](https://youtu.be/vagyIcmIGOQ?si=cDQDaZ8tj4igfgmO&t=9557)). That's what I want, especially for personal projects, and that's what I feel like I can achieve with Swift.

I took another look at the code for my Svelte site and did not see poetry. I saw long, ugly, inline Tailwind classes, large `script` and `head` blocks for even the most straightforward pages, and a project structure that works fine but that I simply find cumbersome. Granted, I chose to use Tailwind, and I'm not the world's greatest web developer—I'm sure there are much more poetic Svelte sites out there—but I was not going to be the one to write the next Svelte sonnet.

I compared that to the sample Ignite code in Swift, and I saw the opportunity to massively simplify my codebase with my favorite language.

## Ignition

With Ignite ready for production and DHH's code poetry ringing in my ears, I was ready to roll. Suddenly I could write "web" code that looked just like the SwiftUI I know and love.

Let's start with an example. This is `Blog.swift`, which renders my 'Blog' page with a reverse-chronological list of posts, and styles them with my own `DynamicArticlePreviewStyle`:

```swift
struct Blog: StaticPage {
    @Environment(\.articles) var articles

    var title = "Ryan Token - Blog"
    var description = "All of Ryan's blog posts."
    var image: URL? = URL(static: Constants.staticProfileImagePath)

    var sortedArticles: [Article] {
        articles.all.sorted(by: \.date).reversed()
    }

    var body: some HTML {
        HeaderText("Blog", size: .h2)
        SubheaderText("All blog posts. Subscribe to my [RSS feed](/feed.rss).")
            .padding(.bottom)

        ForEach(sortedArticles) { article in
            ArticlePreview(for: article)
                .articlePreviewStyle(DynamicArticlePreviewStyle())
        }
    }
}
```

That's it. That's the *entire* Swift file. Poetry, I tell you. And it looks just like SwiftUI! Nearly every file across the website is so much clearer and more concise than what I had to do to achieve the same results in Svelte.

I don't think there's much value in me showing you *how* to set up an Ignite site: Paul's own [Ignite Samples](https://ignitesamples.hackingwithswift.com) website has most of the reference material you'll need. There are, however, a couple of aspects not covered in his samples that I wanted for my site. It took some minor digging on my part to figure them out, so I'll share those here:

1. Syntax highlighting in markdown
2. Configuring the RSS feed

### Syntax highlighting in markdown

While Ignite offers the [Code and CodeBlock](https://ignitesamples.hackingwithswift.com/code-examples/) structs for syntax highlighting within your Swift files, you can't use those in markdown. I use markdown files in the [Content](https://ignitesamples.hackingwithswift.com/content-examples/) folder to render my blog posts, many of which contain code samples, so I needed to figure this out.

The answer is two-fold and quite simple:
1. You need to add a `syntaxHighlighterConfiguration` to your main `Site` struct:
    ```swift
    var syntaxHighlighterConfiguration: SyntaxHighlighterConfiguration = .init(languages: [.swift])
    ```

2. You can then set a `syntaxHighlighterTheme` in your `Theme` file like so:
    ```swift
    // light mode syntax highlighter theme
    struct LightTheme: BaseTheme {
        var colorScheme: ColorScheme = .light
        var syntaxHighlighterTheme: HighlighterTheme { .solarizedLight }
    }
    
    // dark mode syntax highlighter theme
    struct DarkTheme: BaseTheme {
        var colorScheme: ColorScheme = .dark
        var syntaxHighlighterTheme: HighlighterTheme { .githubDark }
    }
    ```

And that's it! Now when you make a code block like this in markdown, it will be nicely formatted with your choice of syntax highlighter theme:

````swift
```swift
struct SocialProfile {
    let url: String
    let icon: String // from icons.getbootstrap.com
    let iconDescription: String
    let lightModeColor: String // Hex color for light mode
    let darkModeColor: String  // Hex color for dark mode
}
```
````

### Configuring the RSS feed

I love [RSS](https://www.rssboard.org/rss-specification). I've supported it on my website for years, and the majority of what I read gets to me via RSS. Supporting it again in this rewrite was a non-negotiable. While I figured Ignite had a way to generate an RSS feed from your content, I didn't see any official documentation or samples showing it.

It was, of course, supported—and it's one of my favorite parts of Ignite. In fact, you get it for free! Every Ignite site gets a default implementation of `FeedConfiguration`, which looks like this: 

```swift
static let `default` = FeedConfiguration(mode: .descriptionOnly, contentCount: 20, path: "/feed.rss")
```

That means if you're using the `Content` folder for your blog posts, you automatically get RSS feed generation at `https://your-website.com/feed.rss` with the basic details for your twenty most recent posts—no RSS-specific code required.

Just awesome. I wanted to customize my feed though, and that's nicely supported as well. In your main `Site` struct, you can define your own feed configuration like this: 

```swift
var feedConfiguration = FeedConfiguration(mode: .full, contentCount: 1000, path: "/feed.rss")
```

That will generate an RSS feed that includes the full content of all my posts. One line of configuration code to customize the feed! Beautiful.

## Speed and Simplicity

Due to the simplicity of Ignite and the HTML it generates, the Ignite site loads noticeably faster than my previous SvelteKit site. SvelteKit is no slouch when it comes to bundle size and speed—that's why I chose [SvelteKit over Nuxt 3](/blog/nuxt-3-vs-sveltekit) in the first place. But Ignite beats out even SvelteKit in page load speed. Try loading them yourself:
* SvelteKit site: [https://ryantoken-v3-svelte.vercel.app/](https://ryantoken-v3-svelte.vercel.app/)
* Ignite site (this site): [https://www.ryantoken.com](https://www.ryantoken.com)

Ignite's simplicity is shown in some of the code samples above, but it's also clearly demonstrated in the total lines of code required to build each site. Here's the breakdown, counted by [cloc](https://github.com/AlDanial/cloc):

**SvelteKit**: **2,974 total lines of code**
* Excludes SvelteKit's `build` directory, `node_modules`, hidden files and folders, and `package-lock.json`

```
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Markdown                        15            849              0           1486
Svelte                          22            306              4           1146
JavaScript                      11             33              7            170
CSS                              2             17              8             99
JSON                             4              0              0             53
HTML                             1              0              4             17
Text                             2              0              0              3
-------------------------------------------------------------------------------
SUM:                            57           1205             23           2974
-------------------------------------------------------------------------------
```

**Ignite**: **2,479 total lines of code**
* Excludes the `Build` folder and all hidden files and folders

*Note that the Ignite site also has an additional blog post that the SvelteKit site doesn't have (this blog post)*

```
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Markdown                        15            838              0           1402
Swift                           31            275            187           1067
HTML                             6              2              0             10
-------------------------------------------------------------------------------
SUM:                            52           1115            187           2479
-------------------------------------------------------------------------------
```

Nearly 500 fewer lines of code! A 17% reduction. For a simple site like this, that is significant.

This rewrite confirmed something I suspected but hadn't fully experienced: Swift really can make web development feel as elegant as writing SwiftUI. The code just flows in a way that my Svelte setup never did. And those five hundred fewer lines of code? That's not just a smaller bundle—it's code that represents clearer intent, better organization, and better maintainability.

## Catching Fire

I am genuinely stoked about Ignite. It feels like it was made for developers like me and comes with so many obvious wins:

1. Building websites with Swift, my favorite language
2. Styling them with a SwiftUI-like syntax
3. The simplest blog + markdown setup I have ever used
4. A simple and powerful [theming engine](https://ignitesamples.hackingwithswift.com/theme-examples/)
5. Automatically generating my [valid](https://validator.w3.org/feed/check.cgi?url=https%3A%2F%2Fwww.ryantoken.com%2Ffeed.rss) RSS feed with little to no config
6. The ability to [inject](https://ignitesamples.hackingwithswift.com/include-examples/) arbitrary HTML and JavaScript when necessary
7. Built-in Bootstrap integration for responsive design
8. Excellent performance out of the box

<br />

![Ignite logo](/images/ignite.png)

<br />

Rewriting my website with Ignite was an absolute joy, and I did it in less than a week! SvelteKit remains a wonderful framework, but it's much more powerful than what I need for a simple static site like this. Ignite is tailor-made for developers like me who love Swift and SwiftUI, and want to bring that same elegance and simplicity to the web. I couldn't be happier with the results.

If you're a Swift developer who's been curious about web development, or if you're looking for a simpler way to build static sites, I can't recommend Ignite highly enough. It's another feather in the cap of "Swift everywhere."

Thanks for reading, and feel free to [get in touch](mailto:ryan@ryantoken.com) if you have feedback on this blog post or the site in general. I'd love to hear from you!

And if you particularly enjoyed this post, you can [buy me a coffee](https://www.buymeacoffee.com/ryantoken)!

[<img src="/images/bmc-button.png" class="img-fluid w-50">](https://www.buymeacoffee.com/ryantoken)

<br />

You can view the source code for this website on **GitHub**: [https://github.com/ryan-token/ryantoken.com-v4-ignite](https://github.com/ryan-token/ryantoken.com-v4-ignite)

<br /> <br />

**Previous posts in the *Swift Everywhere* series**:
* [Serverless Swift](/blog/serverless-swift) (a.k.a. Swift Everywhere: Serverless Edition)
