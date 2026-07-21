//
//  HomeTab.swift
//  AniHyou
//
//  Created by Axel Lopez on 17/10/2023.
//

import Foundation
import SwiftUI

enum HomeTab: Int, CaseIterable {
    case current = 2
    case activity = 1
}

extension HomeTab {
    var localizedName: LocalizedStringKey {
        switch self {
        case .activity:
            "Activity"
        case .current:
            "Current"
        }
    }
    
    var systemImage: String {
        switch self {
        case .activity:
            "text.bubble"
        case .current:
            "play.circle"
        }
    }
}
