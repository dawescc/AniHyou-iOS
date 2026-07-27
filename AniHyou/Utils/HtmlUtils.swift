//
//  HtmlUtils.swift
//  AniHyou
//
//  Created by Axel on 22/07/2026.
//

import Foundation
import RegexBuilder

@MainActor
extension String {
    
    private static let linkRegex = Regex {
        "["
        Capture { OneOrMore { CharacterClass.anyOf("]").inverted } }
        "]("
        Capture { OneOrMore { CharacterClass.anyOf(")").inverted } }
        ")"
    }

    private static let boldRegex = /__(.+?)__/
    private static let codeRegex = /`(.+?)`/
    private static let strongRegex = /\*\*(.+?)\*\*/
    
    func formatCompatibleHtml() -> String {
        self
            // Replace AniList Markdown [text](link) with HTML <a>
            .replacing(String.linkRegex) { match in
                "<a href=\"\(match.2)\">\(match.1)</a>"
            }
            // Replace AniList Markdown __bold__ with HTML <b>
            .replacing(String.boldRegex) { match in
                "<b>\(match.1)</b>"
            }
            // Replace AniList Markdown `code` with HTML <code>
            .replacing(String.codeRegex) { match in
                "<code>\(match.1)</code>"
            }
            // Replace AniList Markdown **strong** with HTML <strong>
            .replacing(String.strongRegex) { match in
                "<strong>\(match.1)</strong>"
            }
            // Escaped chars
            .replacingOccurrences(of: "<br />\n", with: "<br/>")
            .replacingOccurrences(of: "\n", with: "<br/>")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
    }
}
