//
//  WriteReviewViewModel.swift
//  AniHyou
//

import Foundation
import AniListAPI

@MainActor
@Observable class WriteReviewViewModel {

    var existingReview: UserMediaReviewQuery.Data.Review?
    
    var isLoading = false
    var saveError = false
    var savedSuccessfully = false
    var deletedSuccessfully = false

    var summary = ""
    var body = ""
    var score = 0
    var isPrivate = false

    static let minBodyLength = 2600
    static let minSummaryLength = 20
    static let maxSummaryLength = 120

    var canSave: Bool {
        body.count >= Self.minBodyLength
            && summary.count >= Self.minSummaryLength
            && summary.count <= Self.maxSummaryLength
            && score > 0
    }
    
    func fetchExistingReview(mediaId: Int) async {
        isLoading = true
        let userId = LoginRepository.authUserId()
        if let result = await ReviewRepository.getUserReview(
            mediaId: mediaId.toInt32(),
            userId: userId.toInt32()
        ) {
            existingReview = result
            summary = result.summary ?? ""
            body = result.body ?? ""
            score = result.score ?? 0
            isPrivate = result.private ?? false
        }
        isLoading = false
    }

    func delete(id: Int) async {
        isLoading = true
        deletedSuccessfully = await ReviewRepository.deleteReview(id: id.toInt32())
        isLoading = false
    }

    func save(mediaId: Int) async {
        isLoading = true
        let success = await ReviewRepository.saveReview(
            id: existingReview?.id.toInt32(),
            mediaId: mediaId.toInt32(),
            body: body,
            summary: summary,
            score: score.toInt32(),
            isPrivate: isPrivate
        )
        isLoading = false
        if success {
            savedSuccessfully = true
        } else {
            saveError = true
        }
    }
}
