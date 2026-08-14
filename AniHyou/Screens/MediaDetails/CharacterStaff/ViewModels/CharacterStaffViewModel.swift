//
//  CharacterStaffViewModel.swift
//  AniHyou
//
//  Created by Axel Lopez on 17/08/2022.
//

import Foundation
import AniListAPI

@MainActor
@Observable class CharacterStaffViewModel {

    var mediaCharactersAndStaff: MediaCharactersAndStaffQuery.Data.Media?
    
    var availableLanguages: [String] = []
    var selectedLanguage: String = "Japanese"

    func getMediaCharactersAndStaff(mediaId: Int) async {
        if let result = await MediaRepository.getMediaCharactersAndStaff(mediaId: Int32(mediaId)) {
            mediaCharactersAndStaff = result
            if let character = result.characters?.edges?.first??.fragments.mediaCharacter {
                if let languages = character.voiceActors?.compactMap({ $0?.languageV2 }) {
                    availableLanguages = languages
                    if let firstLanguage = languages.first {
                        selectedLanguage = firstLanguage
                    }
                }
            }
        }
    }
}
