//
//  EditCustomListsView.swift
//  AniHyou
//
//  Created by Axel on 14/08/2026.
//

import SwiftUI
import AniListAPI

struct EditCustomListsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = EditCustomListsViewModel()
    
    var body: some View {
        List {
            buildList(.anime)
            buildList(.manga)
        }
        .navigationTitle("Custom lists")
        .toolbar {
            toolbarContent
        }
        .task {
            await viewModel.fetchLists()
        }
        .onChange(of: viewModel.wasUpdated) {
            if viewModel.wasUpdated { dismiss() }
        }
    }
    
    @ViewBuilder
    func buildList(_ type: MediaType) -> some View {
        Section(type.localizedName) {
            let list = if type == .anime { $viewModel.animeLists } else { $viewModel.mangaLists }
            let newList = if type == .anime { $viewModel.newAnimeList } else { $viewModel.newMangaList }
            ForEach(list, id: \.self, editActions: .delete) { list in
                Text(list.wrappedValue)
            }
            TextField("Add", text: newList)
                .lineLimit(1)
                .onSubmit {
                    viewModel.addNewList(type)
                }
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save", systemImage: "checkmark") {
                Task {
                    await viewModel.updateCustomLists()
                }
            }
        }
    }
}

#Preview {
    EditCustomListsView()
}
