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

    var canSave: Bool {
        body.count >= 2600 && summary.count >= 20 && summary.count <= 120 && score > 0
    }

    func delete(id: Int) async {
        isSaving = true
        deletedSuccessfully = await ReviewRepository.deleteReview(id: Int32(id))
        isSaving = false
    }

    func save(id: Int?, mediaId: Int) async {
        isSaving = true
        let success = await ReviewRepository.saveReview(
            id: id.map { Int32($0) },
            mediaId: Int32(mediaId),
            body: body,
            summary: summary,
            score: Int32(score),
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
