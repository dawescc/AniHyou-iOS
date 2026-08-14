//
//  CustomListsViewModel.swift
//  AniHyou
//
//  Created by Axel on 14/08/2026.
//

import Foundation
import AniListAPI

@MainActor
@Observable class EditCustomListsViewModel {
    
    var animeLists: [String] = []
    var mangaLists: [String] = []
    var newAnimeList: String = ""
    var newMangaList: String = ""
    var wasUpdated = false
    
    func fetchLists() async {
        if let result = await UserRepository.getUserOptions() {
            if let animeLists = result.mediaListOptions?.animeList?.customLists {
                self.animeLists = animeLists.compactMap({ $0 })
            }
            if let mangaLists = result.mediaListOptions?.mangaList?.customLists {
                self.mangaLists = mangaLists.compactMap({ $0 })
            }
        }
    }
    
    func updateCustomLists() async {
        if let result = await UserRepository.updateCustomLists(animeLists: animeLists, mangaLists: mangaLists) {
            if let animeLists = result.mediaListOptions?.animeList?.customLists?.compactMap({ $0 }) {
                UserDefaults.standard.set(animeLists, forKey: ANIME_CUSTOM_LISTS_KEY)
            }
            if let mangaLists = result.mediaListOptions?.mangaList?.customLists?.compactMap({ $0 }) {
                UserDefaults.standard.set(mangaLists, forKey: MANGA_CUSTOM_LISTS_KEY)
            }
            wasUpdated = true
        }
    }
    
    func addNewList(_ type: MediaType) {
        if type == .anime && !newAnimeList.isBlank() {
            animeLists.append(newAnimeList)
            newAnimeList = ""
        } else if !newMangaList.isBlank() {
            mangaLists.append(newMangaList)
            newMangaList = ""
        }
    }
}
