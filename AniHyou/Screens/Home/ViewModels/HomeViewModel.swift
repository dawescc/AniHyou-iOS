//
//  HomeViewModel.swift
//  AniHyou
//
//  Created by Axel Lopez on 08/09/2024.
//

import Foundation
import SwiftUI

@MainActor
@Observable class HomeViewModel {
    
    var unreadNotificationsCount = 0
    var isLoadingNotifications = false
    
    func getUnreadNotificationsCount() async {
        guard !isLoadingNotifications else { return }
        isLoadingNotifications = true
        defer { isLoadingNotifications = false }
        unreadNotificationsCount = await UserRepository.getUnreadNotificationsCount() ?? 0
    }
}
