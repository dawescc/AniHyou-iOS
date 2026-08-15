//
//  UserActivityView.swift
//  AniHyou
//
//  Created by Axel Lopez on 17/08/2022.
//

import SwiftUI
import AniListAPI

struct UserActivityView: View {

    let userId: Int
    let isMyProfile: Bool
    @State private var viewModel = UserActivityViewModel()
    @Environment(\.scoreFormat) private var scoreFormat: ScoreFormat
    @AppStorage(BLUR_ADULT_MEDIA) private var blurAdultMedia = true

    var body: some View {
        Group {
            if !isMyProfile {
                HStack {
                    Spacer()
                    NavigationLink("Anime List") {
                        MediaListStatusView(mediaType: .anime, userId: userId)
                            .environment(\.scoreFormat, scoreFormat) // for some reason this is required
                            .id(userId)
                    }
                    Spacer()
                    NavigationLink("Manga List") {
                        MediaListStatusView(mediaType: .manga, userId: userId)
                            .environment(\.scoreFormat, scoreFormat)
                            .id(userId)
                    }
                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
            }
            
            ForEach(viewModel.activities, id: \.id) { item in
                if let listActivity = item.asListActivity?.fragments.listActivityFragment {
                    ListActivityItemView(
                        activity: listActivity,
                        blurCover: blurAdultMedia && listActivity.media?.isAdult == true,
                        isMine: listActivity.userId == userId
                    )
                } else if let textActivity = item.asTextActivity?.fragments.textActivityFragment {
                    TextActivityItemView(
                        activity: textActivity,
                        isMine: textActivity.userId == userId
                    )
                } else if let messageActivity = item.asMessageActivity?.fragments.messageActivityFragment {
                    MessageActivityItemView(
                        activity: messageActivity,
                        isMine: messageActivity.messengerId == userId
                    )
                }
                Divider()
                    .onAppear {
                        if item == viewModel.activities.last {
                            Task {
                                await viewModel.getUserActivity()
                            }
                        }
                    }
            }
            if viewModel.isLoading || viewModel.activities.isEmpty {
                HorizontalProgressView()
                    .task {
                        viewModel.userId = userId
                        await viewModel.getUserActivity()
                    }
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
    ScrollView(.vertical) {
        LazyVStack(alignment: .leading) {
            UserActivityView(userId: 208863, isMyProfile: false)
        }
    }
}
