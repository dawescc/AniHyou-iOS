//
//  MediaDetailsMainInfo.swift
//  AniHyou
//
//  Created by Axel Lopez on 23/7/22.
//

import SwiftUI

private let coverWidth: CGFloat = 110
private let coverHeight: CGFloat = 153

struct MediaDetailsMainInfo: View {

    let mediaId: Int
    var viewModel: MediaDetailsViewModel
    
    @State private var showingCoverSheet = false
    @State private var showingPlayPopover = false

    var body: some View {
        HStack(alignment: .top) {

            Button(action: { showingCoverSheet.toggle() }) {
                MediaCoverView(
                    imageUrl: viewModel.mediaDetails?.coverImage?.large,
                    width: coverWidth,
                    height: coverHeight
                )
            }

            VStack(alignment: .leading) {

                Text(viewModel.mediaDetails?.title?.userPreferred ?? "")
                    .font(.title3)
                    .bold()
                    .lineLimit(3)
                    .padding(.bottom, 1)
                    .textSelection(.enabled)

                VStack(alignment: .leading, spacing: 8) {
                    if let mediaFormat = viewModel.mediaDetails?.format?.value {
                        Label(mediaFormat.localizedName, systemImage: mediaFormat.systemImage)
                    } else {
                        Text("Unknown")
                    }
                    
                    durationTextView
                    
                    if let mediaStatus = viewModel.mediaDetails?.status?.value,
                       let mediaType = viewModel.mediaDetails?.type?.value {
                        Label(mediaStatus.localizedName, systemImage: mediaType.statusSystemImage)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
            }//:VStack
            .padding(.leading, 12)
            .padding(.trailing, 8)
        }//:HStack
        .padding(.top)
        .padding(.leading)
        .sheet(isPresented: $showingCoverSheet) {
            FullCoverView(imageUrl: viewModel.mediaDetails?.coverImage?.extraLarge)
        }
    }
    
    @ViewBuilder
    var durationTextView: some View {
        if viewModel.mediaDetails?.type?.value == .manga {
            if viewModel.mediaDetails?.format?.value == .novel,
                let volumes = viewModel.mediaDetails?.volumes {
                Label("^[\(volumes) volume](inflect: true)", systemImage: "bookmark")
            } else if let chapters = viewModel.mediaDetails?.chapters {
                Label("^[\(chapters) chapter](inflect: true)", systemImage: "bookmark")
            } else {
                Text("Unknown")
            }
        } else if let episodes = viewModel.mediaDetails?.episodes {
            if let duration = viewModel.mediaDetails?.duration, episodes <= 1 {
                let durationText = TimeInterval(duration * 60)
                    .formatted(units: [.hour, .minute], unitsStyle: .abbreviated)
                Label(durationText ?? "Unknown", systemImage: "timer")
            } else if episodes > 0 {
                Label("^[\(episodes) episode](inflect: true)", systemImage: "timer")
            } else {
                Text("Unknown")
            }
        } else {
            Text("Unknown")
        }
    }
}

#Preview {
    MediaDetailsMainInfo(mediaId: 1, viewModel: MediaDetailsViewModel())
}
