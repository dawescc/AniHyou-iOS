//
//  RichTextUtils.swift
//  AniHyou
//
//  Created by Axel Lopez on 05/04/2024.
//

import Foundation
import SwiftUI
import RichText

extension RichText {
    func defaultStyle() -> RichText {
        self
            .imageRadius(8)
            .linkColor(light: .tintColor, dark: .tintColor)
            .placeholder {
                ProgressView()
            }
            .customCSS(RichText.spoilerCss)
    }
    
    private static let spoilerCss =
        """
        .markdown_spoiler {
            color: grey;
            background-color: grey;
        }
        
        .markdown_spoiler:not(:hover):not(:focus):not(:active) {
            color: grey;
        }

        .markdown_spoiler:hover, .markdown_spoiler:focus, .markdown_spoiler:active {
            background-color: transparent;
        }
        """
}
