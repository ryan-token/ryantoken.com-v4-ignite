//
//  OptimizedImages.swift
//  RyanToken.com
//

import CryptoKit
import Foundation

/// The smaller copies of site images that `Scripts/optimize-images.sh` makes: a
/// WebP beside each PNG/JPEG, and a 512px copy of each large square image.
///
/// When the script makes an image's copies, it records the image's SHA-256 in
/// `Scripts/optimize-images.manifest`. Copies are served only while the image still
/// matches that hash, so an image replaced without rerunning the script falls back
/// to the original (and the build warns) rather than serving an outdated copy.
/// Hashes are used rather than modification times because git doesn't preserve
/// those.
struct OptimizedImages: Sendable {
    /// Read once per build: the images don't change while the site is published.
    static let current = OptimizedImages()

    /// Site paths (`/images/…`) whose copies were made from their current contents.
    private let upToDate: Set<String>
    /// Site paths of images changed since the script last made their copies.
    let outdated: [String]
    private let imagesDirectory: URL?

    private init() {
        guard let root = try? PackageDirectory.url() else {
            upToDate = []
            outdated = []
            imagesDirectory = nil
            return
        }

        let imagesDirectory = root.appending(path: "Assets/images")
        let manifest = (try? String(
            contentsOf: root.appending(path: "Scripts/optimize-images.manifest"),
            encoding: .utf8
        )) ?? ""

        var upToDate = Set<String>()
        var outdated: [String] = []

        // Each line is `<sha256>  <path relative to Assets/images>`, as shasum writes it.
        for line in manifest.split(separator: "\n") {
            guard let separator = line.firstRange(of: "  ") else { continue }

            let recordedHash = line[..<separator.lowerBound]
            let relativePath = String(line[separator.upperBound...])
            let sitePath = "/images/\(relativePath)"

            guard let data = try? Data(contentsOf: imagesDirectory.appending(path: relativePath)) else { continue }

            if Self.hexDigest(of: data) == recordedHash {
                upToDate.insert(sitePath)
            } else {
                outdated.append(sitePath)
            }
        }

        self.upToDate = upToDate
        self.outdated = outdated.sorted()
        self.imagesDirectory = imagesDirectory
    }

    /// The 512px copy of a large square image (`/images/x/icon.png` →
    /// `/images/x/icon-512.png`), if it's current.
    func iconCopy(of path: String) -> String? {
        let base = (path as NSString).deletingPathExtension
        return currentCopy(of: path, at: "\(base)-512.\((path as NSString).pathExtension)")
    }

    /// The WebP copy of a PNG/JPEG (`/images/x/shot.png` → `/images/x/shot.webp`),
    /// if it's current.
    func webpCopy(of path: String) -> String? {
        let webpPath = (path as NSString).deletingPathExtension + ".webp"
        guard webpPath != path else { return nil }
        return currentCopy(of: path, at: webpPath)
    }

    private func currentCopy(of path: String, at copyPath: String) -> String? {
        guard upToDate.contains(path),
              let imagesDirectory,
              FileManager.default.fileExists(
                  atPath: imagesDirectory.appending(path: String(copyPath.trimmingPrefix("/images/"))).path
              )
        else { return nil }

        return copyPath
    }

    private static func hexDigest(of data: Data) -> String {
        SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }
}
