//
//  PackageDirectory.swift
//  RyanToken.com
//
//  Created by Ryan Token on 7/28/26.
//

import Foundation

/// Locates the package root, so build-time code can reach `Content` and `Build`
/// regardless of the working directory it's run from.
enum PackageDirectory {
    static func url() throws -> URL {
        var directory = URL(filePath: #filePath).deletingLastPathComponent()

        while directory.path != "/" {
            if FileManager.default.fileExists(atPath: directory.appending(path: "Package.swift").path) {
                return directory
            }
            directory.deleteLastPathComponent()
        }

        throw PackageDirectoryError.notFound
    }
}

enum PackageDirectoryError: LocalizedError {
    case notFound

    var errorDescription: String? {
        switch self {
        case .notFound: "Could not locate Package.swift above the source directory."
        }
    }
}
