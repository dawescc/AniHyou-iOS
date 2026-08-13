//
//  UserActivityViewModel.swift
//  AniHyou
//
//  Created by Axel Lopez on 17/08/2022.
//

import Foundation
import AniListAPI

@MainActor
@Observable class UserActivityViewModel {

    var userId: Int?
    var currentPage: Int32 = 1
    var hasNextPage = false

    var activities = [UserActivityQuery.Data.Page.Activity]()

    func getUserActivity() async {
        guard let userId else { return }
        if let result = await UserRepository.getUserActivity(userId: Int32(userId), page: currentPage) {
            activities.append(contentsOf: result.data)
            currentPage = result.page
            hasNextPage = result.hasNextPage
        }
    }
    
    func refresh() async {
        hasNextPage = false
        currentPage = 1
        activities.removeAll()
        await getUserActivity()
    }
}
