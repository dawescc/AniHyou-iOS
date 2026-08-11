//
//  WriteReviewView.swift
//  AniHyou
//

import SwiftUI

struct WriteReviewView: View {
    @Environment(\.dismiss) private var dismiss

    let mediaId: Int

    @State private var viewModel = WriteReviewViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Summary", text: $viewModel.summary, axis: .vertical)
                        .lineLimit(2...4)
                } header: {
                    Text("Summary")
                } footer: {
                    Text("\(viewModel.summary.count)/120, min 20")
                        .foregroundStyle(.secondary)
                }

                Section {
                    TextEditor(text: $viewModel.body)
                        .frame(minHeight: 200)
                } header: {
                    Text("Review")
                } footer: {
                    if viewModel.body.count < 2600 {
                        Text("\(2600 - viewModel.body.count) more characters required")
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(viewModel.body.count) characters")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Score (1–100)") {
                    Stepper("\(viewModel.score)",
                            value: $viewModel.score,
                            in: 0...100)
                }

                Section {
                    Toggle("Private", isOn: $viewModel.isPrivate)
                }
            }
            .navigationTitle("Write Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Button("Save") {
                            Task { await viewModel.save(id: nil, mediaId: mediaId) }
                        }
                        .disabled(!viewModel.canSave)
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.saveError) {
                Button("OK", role: .cancel) {}
            }
            .onChange(of: viewModel.savedSuccessfully) {
                if viewModel.savedSuccessfully { dismiss() }
            }
        }
    }
}
