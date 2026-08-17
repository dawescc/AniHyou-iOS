//
//  MediaListScoreIndicator.swift
//  AniHyou
//
//  Created by Axel Lopez on 25/05/2023.
//

import SwiftUI
import AniListAPI

struct MediaListScoreIndicator: View {

    let score: Double
    var showTotal: Bool = false
    @Environment(\.scoreFormat) private var format: ScoreFormat
    @AppStorage(HIDE_SCORES) private var hideScores = false
    var color: Color {
        format.color(score: Int(round(score)))
    }

    var body: some View {
        if hideScores {
            EmptyView()
        } else {
            switch format {
            case .point100, .point10, .point5:
                HStack(alignment: .center, spacing: 0) {
                    if score == 0 {
                        Text(UNKNOWN_CHAR)
                    } else {
                        Text(String(Int(score)))
                    }
                    if showTotal {
                        Text("/\(format.maxValue)")
                            .foregroundStyle(.secondary)
                    }
                    Image(systemName: "star.fill")
                        .padding(.leading, 4)
                }
                .foregroundStyle(color)
                .font(.footnote)
            case .point10Decimal:
                HStack(alignment: .center, spacing: 0) {
                    if score == 0 {
                        Text(UNKNOWN_CHAR)
                    } else {
                        Text(score.formatted())
                    }
                    if showTotal {
                        Text("/\(format.maxValue)")
                            .foregroundStyle(.secondary)
                    }
                    Image(systemName: "star.fill")
                        .padding(.leading, 4)
                }
                .foregroundStyle(color)
                .font(.footnote)
            case .point3:
                if let icon = format.smileyIcon(score: Int(score)) {
                    Image(icon)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(color)
                } else {
                    Text(UNKNOWN_CHAR)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
            }
        }
    }
}

#Preview {
    VStack(alignment: .trailing) {
        MediaListScoreIndicator(score: 0)
            .environment(\.scoreFormat, .point100)
        MediaListScoreIndicator(score: 2.8)
            .environment(\.scoreFormat, .point10Decimal)
        MediaListScoreIndicator(score: 3)
            .environment(\.scoreFormat, .point3)
    }
}
