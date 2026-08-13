//
//  PublishActivityViewModel.swift
//  AniHyou
//
//  Created by Axel on 13/08/2026.
//

import Foundation
import AniListAPI

@MainActor
@Observable class PublishActivityViewModel {
    
    var isLoading = false
    var wasPublished = false
    
    func publishActivity(id: Int?, text: String) async {
        isLoading = true
        if let result = await ActivityRepository.updateTextActivity(id: id?.toInt32(), text: text) {
            NotificationCenter.default.post(name: "updatedActivity", object: result)
            wasPublished = true
        }
        isLoading = false
    }
    
    func publishActivityReply(activityId: Int, id: Int?, text: String) async {
        isLoading = true
        if let result = await ActivityRepository.updateActivityReply(
            activityId: activityId.toInt32(),
            id: id?.toInt32(),
            text: text
        ) {
            NotificationCenter.default.post(name: "updatedActivityReply", object: result)
            wasPublished = true
        }
        isLoading = false
    }
}
