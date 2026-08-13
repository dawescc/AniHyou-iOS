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
    @State private var showingReplySheet = false
    
    let activityId: Int
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                
                mainActivityItemView
                    .padding(.top)
                
                Divider()
                
                activityRepliesView
                    .padding(.bottom)
                
                if viewModel.isLoading {
                    HorizontalProgressView()
                        .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Activity")
        .toolbar {
            toolbarContent
        }
        .sheet(isPresented: $showingReplySheet) {
            PublishActivityView(activityId: activityId)
        }
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
    
    @ViewBuilder
    private var mainActivityItemView: some View {
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
    
    private var activityRepliesView: some View {
        ForEach(viewModel.replies, id: \.id) {
            ActivityReplyItemView(
                reply: $0,
                isMine: $0.userId == userId
            )
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Button("Reply", systemImage: "arrowshape.turn.up.left") {
                showingReplySheet = true
            }
            .tint(nil)
        }
    }
}

#Preview {
    ActivityDetailsView(activityId: 1)
}
