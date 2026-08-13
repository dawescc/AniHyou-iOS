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
    @State private var showingPublishActivity = false
    
    var body: some View {
        VStack {
            ForEach(viewModel.activities, id: \.self) {
                if let textActivity = $0.asTextActivity?.fragments.textActivityFragment {
                    TextActivityItemView(activity: textActivity)
                    Divider()
                } else if let listActivity = $0.asListActivity?.fragments.listActivityFragment {
                    ListActivityItemView(
                        activity: listActivity,
                        blurCover: blurAdultMedia && listActivity.media?.isAdult == true
                    )
                    Divider()
                }
            }
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
        .toolbar {
            ToolbarItem {
                Menu {
                    Menu("Activity type") {
                        Picker("Activity type", selection: $viewModel.type) {
                            ForEach(ActivityFeedType.allCases, id: \.self) { type in
                                Text(type.lozalizedName).tag(type)
                            }
                        }
                        .onChange(of: viewModel.type) {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                    }
                    Menu("Feed type") {
                        Picker("Feed type", selection: $viewModel.isFollowing) {
                            Text("Following").tag(true)
                            Text("Global").tag(false)
                        }
                        .onChange(of: viewModel.isFollowing) {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
                .tint(nil)
            }
            if #available(iOS 26.0, *) {
                ToolbarSpacer(placement: .automatic)
            }
            
            ToolbarItem {
                Button(action: { showingPublishActivity = true }) {
                    Label("Publish", systemImage: "square.and.pencil")
                }
                .tint(nil)
            }
        }
        .task {
            await viewModel.refresh()
        }
        .onReceive(
            NotificationCenter.default.publisher(for: "updatedActivity")
        ) { notification in
            if notification.object is TextActivityFragment {
                Task {
                    await viewModel.refresh()
                }
            }
        }
        .sheet(isPresented: $showingPublishActivity) {
            PublishActivityView()
        }
    }
}

#Preview {
    ActivityFeedView(viewModel: ActivityFeedViewModel())
}
