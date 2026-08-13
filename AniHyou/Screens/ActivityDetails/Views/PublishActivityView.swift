//
//  PublishActivityView.swift
//  AniHyou
//
//  Created by Axel on 13/08/2026.
//

import SwiftUI

struct PublishActivityView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = PublishActivityViewModel()
    var activityId: Int32?
    var id: Int32?
    @State var text = ""
    
    var body: some View {
        NavigationStack {
            MarkdownEditor(text: $text)
                .toolbar {
                    toolbarContent
                }
        }
        .onChange(of: viewModel.wasPublished) {
            if viewModel.wasPublished { dismiss() }
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if #available(iOS 26, *) {
                Button(action: { dismiss() }) {
                    Label("Cancel", systemImage: "xmark")
                }
                .tint(nil)
            } else {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                let action: () -> Void = {
                    if let activityId {
                        Task {
                            await viewModel.publishActivityReply(activityId: activityId, id: id, text: text)
                        }
                    } else {
                        Task {
                            await viewModel.publishActivity(id: id, text: text)
                        }
                    }
                }
                if #available(iOS 26, *) {
                    Button(action: action) {
                        Label("Save", systemImage: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(text.isEmpty)
                } else {
                    Button("Save", action: action)
                        .font(.bold(.body)())
                        .disabled(text.isEmpty)
                }
            }
        }
    }
}

#Preview {
    PublishActivityView()
}
