//
//  MediaListItemMinimalView.swift
//  AniHyou
//
//  Created by Axel Lopez on 14/01/2023.
//

import SwiftUI
import AniListAPI

struct MediaListItemMinimalView: View {

    let details: BasicMediaDetails?
    let entry: BasicMediaListEntry?
    let schedule: AiringEpisode?
    var showStatus: Bool = false
    let showLowPriority: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(details?.title?.userPreferred ?? "Error loading item")
                .lineLimit(2)

            if let schedule {
                AiringText(
                    episode: schedule.episode,
                    airingAt: schedule.airingAt,
                    episodesBehind: (schedule.episode - 1) - (entry?.progress ?? 0),
                    behindColor: .accentColor,
                    airingColor: .secondary
                )
                .font(.subheadline)
            }

            HStack {
                if showStatus, let status = entry?.status?.value {
                    Image(systemName: status.systemImage)
                        .foregroundStyle(.secondary)
                }
                if let maxProgress = details?.maxProgress(
                    isVolume: entry?.isVolumeProgress == true
                ) {
                    Text("\(entry?.progressPreferred ?? 0)/\(maxProgress)")
                } else {
                    Text("\(entry?.progressPreferred ?? 0)")
                }
                Spacer()
                if let repeatCount = entry?.repeat, repeatCount > 0 {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(.secondary)
                }
                if entry?.notes?.isEmpty == false {
                    Image(systemName: "note.text")
                        .foregroundStyle(.secondary)
                }
                if let priority = entry?.priority, priority > 0 || showLowPriority {
                    Image(systemName: priority.priorityIcon)
                        .foregroundStyle(priority.priorityColor)
                }
                if let score = entry?.score, score > 0 {
                    MediaListScoreIndicator(score: score)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        List(0...4, id: \.self) { _ in
            NavigationLink(destination: {}, label: {
                MediaListItemMinimalView(
                    details: nil,
                    entry: nil,
                    schedule: nil,
                    showLowPriority: true
                )
            })
        }
    }
}
