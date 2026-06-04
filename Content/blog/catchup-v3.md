---
author: Ryan Token
title: CatchUp v3
subtitle: Revisiting my first iOS app with new features and a fresh UI.
date: 2024-04-03 12:00
tags: swiftui, swiftdata, ios, app
published: true
image: https://www.ryantoken.com/images/catchup-v3/catchup-v3-logo.png
alt: CatchUp v3
---

I first launched [CatchUp - Keep in Touch](https://apps.apple.com/us/app/catchup-keep-in-touch/id1358023550) for iOS in May 2018. It was the first app I'd ever released and it was, from a code perspective, objectively pretty bad.

It's now April of 2024 and somehow, despite years of neglect while building [three](https://apps.apple.com/us/app/hot-local-food/id1621818779) [other](https://apps.apple.com/us/app/outrank/id1588983785) [apps](https://apps.apple.com/us/app/chat-by-storyboard/id1662743814), CatchUp still does relatively well on the App Store.

CatchUp is like a first child for me. It marked the beginning of a journey that has shaped my life and career. I still love and use the app weekly. It still helps me stay in touch with those that matter most.

However, due to the aforementioned neglect, it has had obvious bugs and missing features for quite a while. That all changes with CatchUp v3, out today.

## CatchUp v3

CatchUp v3 is a significant improvement across every corner of the app. The core functionality remains - you can still add your contacts and set recurring reminders to CatchUp with people - but everything around it has changed.

First, there's a new auto-updating grid of your next CatchUps. I've found this helpful as I plan my week and get a feel for who I should remember to get in touch with. It looks like this:

![A screenshot of the Next CatchUps grid](/images/catchup-v3/next-catchups.png)

I've also revamped the contact detail screen's design and removed the “Notification Preference” pop-up sheet entirely. Setting your notification preference for a contact now lives fully within the contact detail screen. There's no "Save" step anymore either. The app auto-saves your notification preference every time you change it.

That new contact detail screen looks like this:

![A screenshot of the contact detail screen](/images/catchup-v3/detail-screen.png)

All controls for this contact now live inside this single screen. Additionally, there's a nice new "Next CatchUp" row, which shows the next time you'll get a notification to CatchUp with this person.

## Longstanding Feature Requests

Those are the primary UI improvements, though there are several more UI tweaks here and there that you might notice.

The rest of v3's changes address longstanding feature requests. For example:
* There are now orange unread indicators on the contact rows if it's time to CatchUp with them
* Pulling down on the home screen fetches the latest contact picture and information for all of your selected contacts
  * Previously you had to delete and re-add the contact to update their information
* There is now automatic cloud syncing, so your contacts and notification preferences stay up-to-date across iPhone, iPad, and Mac
  * This involved a fun migration to [SwiftData](https://developer.apple.com/documentation/swiftdata), which dramatically simplified my local storage code

## Still Free with No Ads

CatchUp is, and always will be, completely free with no ads. The tiny bits of money I make from this app come from the in-app Tip Jar. This is a passion project that I genuinely find helpful in my day-to-day life. I do not, nor do I have any incentive to, store your data on my servers or use your data in any way.

I hope that you use the app and find it valuable. If you do, please consider supporting development by leaving a tip in the app. I really do find that motivating. Alternatively, you can [buy me a coffee](https://www.buymeacoffee.com/ryantoken)!

[<img src="/images/bmc-button.png" class="img-fluid w-50">](https://www.buymeacoffee.com/ryantoken)

## Download

Thank you for reading, and thank you for your interest in CatchUp - Keep in Touch. Feel free to reach out via [email](mailto:ryan@ryantoken.com) with any questions or comments.

CatchUp v3 is available on iOS, iPadOS, and macOS. It requires iOS 17. You can download it on the App Store today:

<a href="https://apps.apple.com/us/app/catchup-keep-in-touch/id1358023550" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 125px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1526515200" alt="Download CatchUp v3 on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>
