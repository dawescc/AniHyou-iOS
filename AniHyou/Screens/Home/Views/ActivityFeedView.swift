//
//  ActivityFeedView.swift
//  AniHyou
//
//  Created by Axel Lopez on 17/10/2023.
//

import SwiftUI
import AniListAPI

struct ActivityFeedView: View {
    
    @Bindable var viewModel: ActivityFeedViewModel
    @AppStorage(BLUR_ADULT_MEDIA) private var blurAdultMedia = true
    @AppStorage(USER_ID_KEY, store: .init(suiteName: ANIHYOU_GROUP)) private var userId = 0
    
    var body: some View {
        ForEach(viewModel.activities, id: \.self) {
            if let textActivity = $0.asTextActivity?.fragments.textActivityFragment {
                TextActivityItemView(
                    activity: textActivity,
                    isMine: textActivity.userId == userId
                )
                Divider()
            } else if let listActivity = $0.asListActivity?.fragments.listActivityFragment {
                ListActivityItemView(
                    activity: listActivity,
                    blurCover: blurAdultMedia && listActivity.media?.isAdult == true,
                    isMine: listActivity.userId == userId
                )
                Divider()
            }
        }
        VStack {
            if viewModel.hasNextPage || viewModel.isLoading {
                HorizontalProgressView()
                    .padding()
                    .task {
                        if viewModel.hasNextPage {
                            await viewModel.getActivities()
                        }
                    }
            }
        }
        .task {
            if viewModel.activities.isEmpty {
                await viewModel.refresh()
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: "updatedActivity")
        ) { _ in
            Task {
                await viewModel.refresh()
            }
        }
    }
}

#Preview {
    ActivityFeedView(viewModel: ActivityFeedViewModel())
}
