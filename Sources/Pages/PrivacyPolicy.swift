//
//  PrivacyPolicy.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/16/25.
//

import Ignite

struct PrivacyPolicy: StaticPage {
	var title = "Ryan Token - Privacy Policy"
	var description = "The Privacy Policy for Ryan Token's apps."
	var image: URL? = URL(static: Constants.staticProfileImagePath)

	var body: some HTML {
		HeaderText("Privacy Policy", size: .h2)
		SubheaderText("Long story short: I don't collect any of your data.")

		Divider()

		HeaderText("Basics", size: .h3)

		Text("Your privacy is critically important to me. Your data is your own. None of my apps collect any personal data – all of it lives locally on your device.")

		HeaderText("Which Apps Does This Cover?", size: .h3)

		Text("This Privacy Policy applies to all apps created by Ryan Token, including YouHQ, CatchUp - Keep in Touch, Outrank, and Hot Local Food (collectively, the \"Apps\").")

		HeaderText("Gathering of Personally-Identifying Information", size: .h3)

		Text("The Apps do not transmit any of your data outside of the app.")

		HeaderText("iCloud Sync via CloudKit", size: .h3)

		Text("The Apps use Apple's CloudKit framework to sync your data across your devices that are signed into the same Apple Account. This sync happens entirely within Apple's secure iCloud infrastructure. Your data is encrypted and remains private to you – it is never transmitted to Ryan Token's servers or any third-party services. Only devices signed into your Apple Account can access your synced data. You can disable iCloud sync at any time through your device settings.")

		HeaderText("Protection of Certain Personally-Identifying Information", size: .h3)

		Text("No Personally-Identifying Information is transmitted to external locations when using the Apps.")

		HeaderText("Business Transfers", size: .h3)

		Text("If the Apps, or substantially all of their assets, were acquired, or in the unlikely event that the Apps go out of business or enter bankruptcy, no information would be acquired by the third party. You acknowledge that such transfers may occur, but understand that no personal information would be acquired.")

		HeaderText("Privacy Policy Changes", size: .h3)

		Text("Although most changes are likely to be minor, we may change our Privacy Policy from time to time, and in our sole discretion. I encourage visitors to frequently check this page for any changes to the Privacy Policy. Your continued use of the Apps after any change in this Privacy Policy will constitute your acceptance of such change.")

		HeaderText("Limited Warranties", size: .h3)

		Text("We do not warrant the completeness or accuracy of the information published on this website; nor do we commit to ensuring that the website remains available or that the material on the website is kept up to date.")

		Text("To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to this website and the use of this website (including, without limitation, any warranties implied by law in respect of satisfactory quality, fitness for purpose and/or the use of reasonable care and skill).")

		HeaderText("Indemnity", size: .h3)

		Text("You hereby indemnify me and undertake to keep me indemnified against any losses, damages, costs, liabilities and expenses (including, without limitation, legal expenses and any amounts paid by me to a third party in settlement of a claim or dispute on the advice of our legal advisers) incurred or suffered by me arising out of any breach by you of any provision of these terms of use, or arising out of any claim that you have breached any provision of these terms of use.")

		Text(markdown: "*Adapted from the [automattic.com privacy policy](https://automattic.com/privacy/) under a [Creative Commons Sharealike license](https://creativecommons.org/licenses/by-sa/2.5/)*")
			.foregroundStyle(.secondary)
	}
}
