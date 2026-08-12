//
//  WriteReviewViewModel.swift
//  AniHyou
//

import Foundation

@MainActor
@Observable class WriteReviewViewModel {

    var isSaving = false
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

    func delete(id: Int) async {
        isSaving = true
        deletedSuccessfully = await ReviewRepository.deleteReview(id: id.toInt32())
        isSaving = false
    }

    func save(id: Int?, mediaId: Int) async {
        isSaving = true
        let success = await ReviewRepository.saveReview(
            id: id.map { $0.toInt32() },
            mediaId: mediaId.toInt32(),
            body: body,
            summary: summary,
            score: score.toInt32(),
            isPrivate: isPrivate
        )
        isSaving = false
        if success {
            savedSuccessfully = true
        } else {
            saveError = true
        }
    }
}
