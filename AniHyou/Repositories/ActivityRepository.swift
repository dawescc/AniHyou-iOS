//
//  ActivityRepository.swift
//  AniHyou
//
//  Created by Axel Lopez on 09/04/2024.
//

import Foundation
import AniListAPI

struct ActivityRepository {
    
    static func getActivities(
        type: ActivityFeedType,
        isFollowing: Bool,
        page: Int32,
        perPage: Int32 = 25,
        forceReload: Bool
    ) async -> PagedResult<ActivityFeedQuery.Data.Page.Activity>? {
        let typeIn: GraphQLNullable<[GraphQLEnum<ActivityType>?]> =
            type == .all ? .none : .some([.case(type.value!)])
        
        return await Network.fetchPagedResult(
            ActivityFeedQuery(
                page: .some(page),
                perPage: .some(perPage),
                isFollowing: .some(isFollowing),
                typeIn: typeIn
            ),
            forceReload: forceReload,
            extractItems: { $0.page?.activities?.compactMap { $0 } },
            extractPage: { $0.page?.pageInfo?.fragments.commonPage }
        )
    }
    
    static func getActivityDetails(activityId: Int32) async -> ActivityDetailsQuery.Data.Activity? {
        do {
            let result = try await Network.shared.apollo.fetch(
                query: ActivityDetailsQuery(activityId: .some(activityId)),
                cachePolicy: .networkFirst
            )
            return result.data?.activity
        } catch {
            print(error)
            return nil
        }
    }
    
    static func updateTextActivity(id: Int32? = nil, text: String) async -> TextActivityFragment? {
        do {
            let result = try await Network.shared.apollo.perform(
                mutation: UpdateTextActivityMutation(id: someIfNotNil(id), text: .some(text))
            )
            return result.data?.saveTextActivity?.fragments.textActivityFragment
        } catch {
            print(error)
            return nil
        }
    }
    
    static func updateActivityReply(
        activityId: Int32,
        id: Int32? = nil,
        text: String
    ) async -> ActivityReplyFragment? {
        do {
            let result = try await Network.shared.apollo.perform(
                mutation: UpdateActivityReplyMutation(
                    activityId: .some(activityId),
                    id: someIfNotNil(id),
                    text: .some(text)
                )
            )
            return result.data?.saveActivityReply?.fragments.activityReplyFragment
        } catch {
            print(error)
            return nil
        }
    }
    
    static func deleteActivity(id: Int32) async -> Bool? {
        do {
            let result = try await Network.shared.apollo.perform(mutation: DeleteActivityMutation(id: .some(id)))
            return result.data?.deleteActivity?.deleted
        } catch {
            print(error)
            return nil
        }
    }
    
    static func deleteActivityReply(id: Int32) async -> Bool? {
        do {
            let result = try await Network.shared.apollo.perform(mutation: DeleteActivityReplyMutation(id: .some(id)))
            return result.data?.deleteActivityReply?.deleted
        } catch {
            print(error)
            return nil
        }
    }
}
