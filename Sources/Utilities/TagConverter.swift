//
//  TagFormatter.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/19/25.
//

struct TagFormatter {
	static func format(_ rawTag: String) -> String {
		let tag = Tag(rawValue: rawTag)
		switch tag {
		case .ai:
			return "AI"
		case .aws:
			return "AWS"
		case .career:
			return "Career"
		case .cloud:
			return "Cloud"
		case .ios:
			return "iOS"
		case .jamstack:
			return "Jamstack"
		case .reflections:
			return "Reflections"
		case .rewrite:
			return "Rewrite"
		case .serverless:
			return "Serverless"
		case .swift:
			return "Swift"
		case .swiftdata:
			return "SwiftData"
		case .swiftui:
			return "SwiftUI"
		case .web:
			return "Web"
		case .webrtc:
			return "WebRTC"
		case nil:
			return rawTag
		}
	}
}
