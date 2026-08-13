//
//  ActivityDetailsView.swift
//  AniHyou
//
//  Created by Axel Lopez on 18/10/2023.
//

import SwiftUI
import AniListAPI

struct ActivityDetailsView: View {
    
    @State private var viewModel = ActivityDetailsViewModel()
    @AppStorage(BLUR_ADULT_MEDIA) private var blurAdultMedia = true
    @AppStorage(USER_ID_KEY, store: .init(suiteName: ANIHYOU_GROUP)) private var userId = 0
    
    let activityId: Int
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                Group {
                    if let listActivity = viewModel.listActivity {
                        ListActivityItemView(
                            activity: listActivity,
                            blurCover: blurAdultMedia && listActivity.media?.isAdult == true,
                            isMine: listActivity.userId == userId
                        )
                    } else if let textActivity = viewModel.textActivity {
                        TextActivityItemView(
                            activity: textActivity,
                            isMine: textActivity.userId == userId
                        )
                    } else if let messageActivity = viewModel.messageActivity {
                        MessageActivityItemView(
                            activity: messageActivity,
                            isMine: messageActivity.messengerId == userId
                        )
                    }
                }
                .padding(.top)
                Divider()
                ForEach(viewModel.replies, id: \.id) {
                    ActivityReplyItemView(reply: $0)
                }
                if viewModel.isLoading {
                    HorizontalProgressView()
                        .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Activity")
        .task {
            await viewModel.getDetails(activityId: activityId)
        }
        .onReceive(
            NotificationCenter.default.publisher(for: "updatedActivity")
        ) { _ in
            Task {
                await viewModel.getDetails(activityId: activityId)
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: "updatedActivityReply")
        ) { _ in
            Task {
                await viewModel.getDetails(activityId: activityId)
            }
        }
    }
}

#Preview {
    ActivityDetailsView(activityId: 1)
}
