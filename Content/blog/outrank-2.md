---
author: Ryan Token
title: Outrank 2.0
subtitle: History charts, stat values, and features I've wanted for years.
date: 2026-11-16 12:00
tags: app, swift, swiftui, serverless
published: true
image: https://www.ryantoken.com/images/outrank-v2/outrank-icon.png
alt: Outrank's app icon
---

[Outrank](https://apps.apple.com/us/app/outrank/id1588983785) turned five a few weeks ago. Today I'm releasing the biggest update it has ever had:

## Outrank 2.0

If you haven't used it before, Outrank shows where your college football team ranks nationally in 47 stats against all 138 FBS teams. Total offense, turnover margin, red zone defense, team sacks: it's all in one list for each team, so you never have to go hunting for stats one at a time.

Version 2.0 adds History charts, the real numbers behind every ranking, redesigned widgets, a new layout for every screen size, and an all-new backend.

<div class="row g-3 mb-4">
<div class="col-4"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-rankings.png" alt="Outrank's rankings screen on iPhone" class="img-fluid"></a></div>
<div class="col-4"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-history.png" alt="Outrank's History chart on iPhone" class="img-fluid"></a></div>
<div class="col-4"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-compare.png" alt="Outrank's Compare screen on iPhone" class="img-fluid"></a></div>
</div>

## What's new

**History charts.** Pick a team and a stat, and you'll see how that ranking has moved day by day over the course of a season. It goes back to every season since 2021, and it shows the team's best and worst days of the season. History is included with any subscription.

<div class="row g-3 mb-4">
<div class="col-12"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-ipad-history.png" alt="Outrank's History chart on iPad" class="img-fluid"></a></div>
</div>

**Stat values.** Knowing your team is 7th in turnover margin is nice. Knowing it's 7th at 1.00 per game, while 1st place sits at 1.90, is a lot more useful. Tap any stat to see every team's actual average next to its rank, and the History charts show the value behind your team's ranking on any given day.

<div class="row g-3 mb-4 justify-content-center">
<div class="col-5"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-stat.png" alt="Every FBS team's ranking and average for one stat on iPhone" class="img-fluid"></a></div>
<div class="col-7"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-duo-outer-stat.png" alt="Every FBS team's ranking and average for one stat on iPhone Duo's outer display" class="img-fluid"></a></div>
</div>

**Redesigned widgets.** The Top Four and Bottom Four widgets have a bold new look that's much easier to read at a glance. Green for the good news, red for the bad.

<div class="row g-3 mb-4 justify-content-center">
<div class="col-12 col-md-9 order-md-2"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-ipad-widgets.png" alt="Outrank's Top Four and Bottom Four widgets on iPad" class="img-fluid"></a></div>
<div class="col-6 col-md-3 order-md-1"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-widgets.png" alt="Outrank's Top Four and Bottom Four widgets on iPhone" class="img-fluid"></a></div>
</div>

**Built for every screen.** Outrank has run on iPhone, iPad, and Mac since day one, and 2.0 gives it a new layout that makes full use of each of them. That includes both displays of iPhone Duo, with rankings and stat details side by side on the big inner display, and everything fitting neatly on the narrow outer one.

<div class="row g-3 mb-4">
<div class="col-12"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-duo-inner-rankings.png" alt="Outrank's rankings and stat detail side by side on iPhone Duo's inner display" class="img-fluid"></a></div>
</div>

<div class="row g-3 mb-4 justify-content-center">
<div class="col-6 col-md-4"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-duo-outer-rankings.png" alt="Outrank's rankings screen on iPhone Duo's outer display" class="img-fluid"></a></div>
<div class="col-12 col-md-8"><a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/outrank-v2/outrank-ipad-compare.png" alt="Outrank's Compare screen on iPad" class="img-fluid"></a></div>
</div>

**Faster, fresher rankings.** An all-new backend loads rankings faster and updates them more often. More on that below.

**Also: a new icon.** Outrank 2.0 gets a new Liquid Glass app icon. I'm very happy with it.

<div class="d-flex align-items-center justify-content-center gap-4 my-4">
<span class="app-icon-link"><img src="/images/outrank/outrank-icon.png" alt="Outrank's original app icon" class="app-icon" style="width: 120px; height: 120px;"></span>
<svg width="40" height="24" viewBox="0 0 40 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" role="img" aria-label="becomes"><path d="M2 12h34M26 3l10 9-10 9"/></svg>
<span class="app-icon-link"><img src="/images/outrank-v2/outrank-icon.png" alt="Outrank's new Liquid Glass app icon" class="app-icon" style="width: 120px; height: 120px;"></span>
</div>

## Years of "someday"

None of these feature or improvement ideas are new. I've been thinking about most of them for literal years.

I've wanted to show the actual stat values since I first built the app in 2021. A ranking without its number only tells you half the story, and I knew it at the time.

I've wanted History charts since Apple introduced [Swift Charts](https://developer.apple.com/documentation/charts) in 2022. The funny part is that I've had the data the entire time. The original backend had been quietly saving a copy of every scrape since 2021, and it was all just sitting in a database table. For 2.0, I cleaned up and backfilled more than 246,000 of those old rows into daily snapshots, and that's what the charts are built on.

And I've wanted to get the scraper off of its EC2 server and go fully serverless since very early on.

So why did it take five years? Honestly, it's because Outrank is a small app. It has never had enough users for me to justify spending my limited free time on it over everything else going on. It worked, and it was good enough for what I mostly use it for: prepping for my podcast, [The Golden Hurricast](https://www.thegoldenhurricast.com). So those features stayed on the someday list.

## A note on AI

What changed this year is that I built most of 2.0 with the help of AI and agentic coding tools.

I know a lot of people have mixed or negative feelings about AI, and I understand why. I'm not here to tell anyone how to feel about it. I can only tell you what it meant for this app: these features were not going to happen without it. The hours and weeks it would have taken to rebuild the backend, migrate five years of data, and redesign the app by hand were hours I was never going to spend on Outrank. With AI's help, the someday list finally got built.

## Goodbye, EC2

Speaking of the backend, this is the part I'm maybe the most excited about.

Since 2021, the scraper that collects every team's rankings has lived on a `t3.micro` EC2 instance. It cost me about $15 a month, every month, just to run a job that takes less than a minute once per day. The other 95% of the time, that server just sat there doing nothing and billing me for it.

The scraper now runs on [AWS Lambda](https://aws.amazon.com/lambda/), twice per day on a schedule, and writes to a single DynamoDB table. Outrank's backend now costs me less than $1 a month compared to the $15/month on EC2. It's also much easier to change, test, and deploy. I'll pick [serverless](/blog/serverless-swift) over a traditional server any day when the use case fits, and a scheduled job that runs twice a day fits it about as well as anything can.

## Still free

Outrank is still free with no ads. Rankings, stat values, team comparisons, and widgets are free for everyone. The new history charts come with any of the optional annual subscriptions, and subscriptions and tips are what keep Outrank going. If you enjoy the app, I'd really appreciate the support.

And as always, I collect and store *none* of your data. I have no interest in it.

## Check it out

Thank you for reading, and for using Outrank, whether it's been five years or five minutes. If you have feedback or a feature request, [send me an email](mailto:ryan@ryantoken.com). I'd love to hear from you.

Outrank 2.0 is available now for iPhone, iPad, and Mac - and it's optimized for iPhone Duo.

<br />

<a href="https://apps.apple.com/us/app/outrank/id1588983785"><img src="/images/app-store-badge.svg" alt="Download Outrank on the App Store" class="img-fluid" style="width: 250px;"></a>
