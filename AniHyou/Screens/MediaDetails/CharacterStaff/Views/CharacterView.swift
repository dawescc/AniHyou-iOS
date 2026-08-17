//
//  CharacterView.swift
//  AniHyou
//
//  Created by Axel Lopez on 2/7/22.
//

import SwiftUI
import AniListAPI

private let imageSize: CGFloat = 70

struct CharacterView: View {

    let character: MediaCharacter?
    let selectedLanguage: String

    var body: some View {
        HStack {
            NavigationLink(destination: CharacterDetailsView(characterId: character!.node!.id)) {
                HStack {
                    CircleImageView(imageUrl: character?.node?.image?.medium, size: imageSize)
                    VStack(alignment: .leading) {
                        Text(character?.node?.name?.userPreferred ?? "")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .foregroundStyle(.primary)
                        Text(character?.role?.value?.localizedName ?? "")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }//:HStack
            }
            .buttonStyle(.plain)

            Spacer()

            if let voiceActors = character?.voiceActors,
               let voiceActor = voiceActors.first(where: { $0?.languageV2 == selectedLanguage }),
               let voiceActor = voiceActor
            {
                NavigationLink(destination: StaffDetailsView(staffId: voiceActor.id)) {
                    HStack {
                        VStack(alignment: .trailing) {
                            Text(voiceActor.name?.userPreferred ?? "")
                                .font(.footnote)
                                .multilineTextAlignment(.trailing)
                                .lineLimit(3)
                                .foregroundStyle(.primary)
                            Text(selectedLanguage)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        CircleImageView(imageUrl: voiceActor.image?.medium, size: imageSize)
                    }//:HStack
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: imageSize)
    }
}

#Preview {
    CharacterView(character: nil, selectedLanguage: "Japanese")
        .padding()
}
