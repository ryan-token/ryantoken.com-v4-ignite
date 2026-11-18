//
//  BuildOutput.swift
//  RyanToken.com
//

import Foundation

/// Helpers shared by the post-processors that correct Ignite's output in `Build`
/// after `site.publish()` finishes.
enum BuildOutput {
    static func directory() throws -> URL {
        try PackageDirectory.url().appending(path: "Build")
    }

    static func rewriteHTMLFiles(in directory: URL, transform: (String) throws -> String) throws {
        guard let files = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil) else { return }

        for case let file as URL in files where file.pathExtension == "html" {
            try rewrite(file, transform: transform)
        }
    }

    static func rewrite(_ file: URL, transform: (String) throws -> String) throws {
        guard let contents = try? String(contentsOf: file, encoding: .utf8) else { return }
        let updated = try transform(contents)
        guard updated != contents else { return }
        try updated.write(to: file, atomically: true, encoding: .utf8)
    }
}

extension String {
    /// Applies `transform` to everything outside `<tag>…</tag>` regions, leaving their
    /// contents untouched.
    func replacingOutsideTag(_ tag: String, _ transform: (Substring) -> String) -> String {
        var result = ""
        var remainder = self[...]

        while let open = remainder.openingTagRange(of: tag) {
            result += transform(remainder[..<open.lowerBound])

            guard let close = remainder.range(of: "</\(tag)>", range: open.upperBound..<remainder.endIndex) else {
                return result + remainder[open.lowerBound...]
            }

            result += remainder[open.lowerBound..<close.upperBound]
            remainder = remainder[close.upperBound...]
        }

        return result + transform(remainder)
    }
}

private extension Substring {
    /// The range of the first `<tag>` or `<tag …>`, skipping longer element names
    /// that merely start with `tag` (e.g. `<pre` within `<preview>`).
    func openingTagRange(of tag: String) -> Range<Index>? {
        var searchStart = startIndex

        while let match = range(of: "<\(tag)", range: searchStart..<endIndex) {
            guard match.upperBound < endIndex else { return nil }

            let next = self[match.upperBound]
            if next == ">" || next.isWhitespace { return match }
            searchStart = match.upperBound
        }

        return nil
    }
}
