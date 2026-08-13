//
//  MarkdownFormat.swift
//  AniHyou
//
//  Created by Axel on 13/08/2026.
//

import SwiftUI

enum MarkdownFormat: Equatable, Hashable, CaseIterable {
    case bold
    case italic
    case underline
    case strikethough
    case spoiler
    case link
    case image
    case youtube
    case video
    case orderedList
    case unorderedList
    case heading
    case centered
    case quote
    case code
}

extension MarkdownFormat: Identifiable {
    var id: Self { self }
}

extension MarkdownFormat {
    var syntax: String {
        switch self {
        case .bold:
            "____"
        case .italic:
            "__"
        case .underline:
            "<u></u>"
        case .strikethough:
            "~~~~"
        case .spoiler:
            "~!!~"
        case .link:
            "[link](%@)"
        case .image:
            "img(%@)"
        case .youtube:
            "youtube(%@)"
        case .video:
            "webm(%@)"
        case .orderedList:
            "\n1. "
        case .unorderedList:
            "\n- "
        case .heading:
            "\n# "
        case .centered:
            "~~~~~~"
        case .quote:
            "\n> "
        case .code:
            "``"
        }
    }
    
    var selectionOffset: Int {
        switch self {
        case .bold:
            2
        case .italic:
            1
        case .underline:
            2
        case .strikethough:
            4
        case .spoiler:
            2
        case .link:
            0
        case .image:
            0
        case .youtube:
            0
        case .video:
            0
        case .orderedList:
            0
        case .unorderedList:
            0
        case .heading:
            0
        case .centered:
            3
        case .quote:
            0
        case .code:
            1
        }
    }
}

extension MarkdownFormat {
    var localizedName: LocalizedStringKey {
        switch self {
        case .bold:
            "Bold"
        case .italic:
            "Italic"
        case .underline:
            "Underline"
        case .strikethough:
            "Strikethough"
        case .spoiler:
            "Spoiler"
        case .link:
            "Link"
        case .image:
            "Image"
        case .youtube:
            "YouTube"
        case .video:
            "Video"
        case .orderedList:
            "Ordered list"
        case .unorderedList:
            "Unordered list"
        case .heading:
            "Heading"
        case .centered:
            "Centered"
        case .quote:
            "Quote"
        case .code:
            "Code"
        }
    }
    
    var systemImage: String {
        switch self {
        case .bold:
            "bold"
        case .italic:
            "italic"
        case .underline:
            "underline"
        case .strikethough:
            "strikethrough"
        case .spoiler:
            "eye.slash"
        case .link:
            "link"
        case .image:
            "photo"
        case .youtube:
            "play.rectangle.fill"
        case .video:
            "film"
        case .orderedList:
            "list.number"
        case .unorderedList:
            "list.bullet"
        case .heading:
            "textformat.size"
        case .centered:
            "text.aligncenter"
        case .quote:
            "text.quote"
        case .code:
            "chevron.left.forwardslash.chevron.right"
        }
    }
}
