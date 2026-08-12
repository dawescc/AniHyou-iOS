//
//  ReviewRepository.swift
//  AniHyou
//
//  Created by Axel Lopez on 09/04/2024.
//

import Foundation
import AniListAPI

struct ReviewRepository {

    static func getReviewDetails(reviewId: Int32) async -> CommonReviewDetails? {
        do {
            let result = try await Network.shared.apollo.fetch(
                query: ReviewDetailsQuery(reviewId: .some(reviewId))
            )
            return result.data?.review?.fragments.commonReviewDetails
        } catch {
            print(error)
            return nil
        }
    }

    static func getUserReview(mediaId: Int32, userId: Int32) async -> UserMediaReviewQuery.Data.Review? {
        do {
            let result = try await Network.shared.apollo.fetch(
                query: UserMediaReviewQuery(mediaId: .some(mediaId), userId: .some(userId)),
                cachePolicy: .networkOnly
            )
            return result.data?.review
        } catch {
            print(error)
            return nil
        }
    }

    // swiftlint:disable:next function_parameter_count
    static func saveReview(
        id: Int32?,
        mediaId: Int32,
        body: String,
        summary: String,
        score: Int32,
        isPrivate: Bool
    ) async -> Bool {
        do {
            let result = try await Network.shared.apollo.perform(
                mutation: SaveReviewMutation(
                    id: someIfNotNil(id),
                    mediaId: mediaId,
                    body: body,
                    summary: summary,
                    score: score,
                    private: .some(isPrivate)
                )
            )
            return result.data?.saveReview != nil
        } catch {
            print(error)
            return false
        }
    }

    static func deleteReview(id: Int32) async -> Bool {
        do {
            let result = try await Network.shared.apollo.perform(
                mutation: DeleteReviewMutation(id: .some(id))
            )
            return result.data?.deleteReview?.deleted == true
        } catch {
            print(error)
            return false
        }
    }

    static func rateReview(
        reviewId: Int32,
        rating: ReviewRating
    ) async -> CommonReviewDetails? {
        do {
            let result = try await Network.shared.apollo.perform(
                mutation: RateReviewMutation(
                    reviewId: .some(reviewId),
                    rating: .some(.case(rating))
                )
            )
            if let data = result.data?.rateReview {
                return try await Network.shared.apollo.store.withinReadWriteTransaction { transaction in
                    do {
                        try await transaction.updateObject(
                            ofType: CommonReviewDetails.self,
                            withKey: "Review:\(reviewId)"
                        ) { (cachedData: inout CommonReviewDetails) in
                            cachedData.userRating = data.userRating
                            cachedData.rating = data.rating
                            cachedData.ratingAmount = data.ratingAmount
                        }
                        let newObject = try await transaction.readObject(
                            ofType: CommonReviewDetails.self,
                            withKey: "Review:\(reviewId)"
                        )
                        return newObject
                    } catch {
                        print(error)
                        return nil
                    }
                }
            }
            return nil
        } catch {
            print(error)
            return nil
        }
    }
}
