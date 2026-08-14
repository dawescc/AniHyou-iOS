//
//  Priority.swift
//  AniHyou
//
//  Created by Axel on 14/08/2026.
//

import SwiftUI

extension Int {
    var priorityName: LocalizedStringKey {
        switch self {
        case 0:
            "Low"
        case 1:
            "Medium"
        case 2:
            "High"
        default:
            "None"
        }
    }
    
    var priorityIcon: String {
        switch self {
        case 0:
            "0.circle"
        case 1:
            "1.circle"
        case 2:
            "2.circle"
        default:
            "questionmark.circle"
        }
    }
    
    var priorityColor: Color {
        switch self {
        case 0:
            .yellow
        case 1:
            .orange
        case 2:
            .red
        default:
            .primary
        }
    }
}
