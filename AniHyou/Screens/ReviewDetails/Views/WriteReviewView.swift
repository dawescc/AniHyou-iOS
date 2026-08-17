//
//  WriteReviewView.swift
//  AniHyou
//

import SwiftUI
import AniListAPI

struct WriteReviewView: View {
    @Environment(\.dismiss) private var dismiss

    let mediaId: Int

    @State private var viewModel = WriteReviewViewModel()
    @State private var showDeleteDialog = false
    private let textFieldWidth: CGFloat = 65

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Summary", text: $viewModel.summary, axis: .vertical)
                        .lineLimit(1...4)
                } header: {
                    Text("Summary")
                } footer: {
                    HStack {
                        Text("\(viewModel.summary.count)/\(WriteReviewViewModel.maxSummaryLength)")
                            .foregroundStyle(.secondary)
                        if viewModel.summary.count < WriteReviewViewModel.minSummaryLength {
                            let requiredCount = WriteReviewViewModel.minSummaryLength - viewModel.summary.count
                            Text("\(requiredCount) more characters required")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section {
                    TextEditor(text: $viewModel.body)
                        .frame(minHeight: 200)
                } header: {
                    Text("Review")
                } footer: {
                    if viewModel.body.count < WriteReviewViewModel.minBodyLength {
                        Text("\(WriteReviewViewModel.minBodyLength - viewModel.body.count) more characters required")
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(viewModel.body.count) characters")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Score") {
                    Label {
                        Stepper(
                            value: $viewModel.score,
                            in: 0...100
                        ) {
                            AutoSizeTextField(
                                value: $viewModel.score,
                                placeholder: "0",
                                trailingText: "/100",
                                formatter: NumberFormatter()
                            )
                            .keyboardType(.numberPad)
                        }
                    } icon: {
                        Image(systemName: "star")
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                }

                Section {
                    Label {
                        Toggle("Private", isOn: $viewModel.isPrivate)
                    } icon: {
                        Image(systemName: viewModel.isPrivate ? "lock" : "lock.open")
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                }

                if let id = viewModel.existingReview?.id {
                    Button(role: .destructive) {
                        showDeleteDialog = true
                    } label: {
                        Label("Delete Review", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                    .confirmationDialog("Delete this review?", isPresented: $showDeleteDialog) {
                        Button("Delete", role: .destructive) {
                            Task { await viewModel.delete(id: id) }
                        }
                    } message: {
                        Text("Delete this review?")
                    }
                }
            }
            .navigationTitle(viewModel.existingReview == nil ? "Write Review" : "Edit Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if #available(iOS 26, *) {
                        Button(action: { dismiss() }) {
                            Label("Close", systemImage: "xmark")
                        }
                        .tint(nil)
                    } else {
                        Button("Close") { dismiss() }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        let action: () -> Void = {
                            Task { await viewModel.save(mediaId: mediaId) }
                        }
                        if #available(iOS 26, *) {
                            Button(action: action) {
                                Label("Save", systemImage: "checkmark")
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(!viewModel.canSave)
                        } else {
                            Button("Save", action: action)
                                .disabled(!viewModel.canSave)
                                .font(.bold(.body)())
                        }
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.saveError) {
                Button("OK", role: .cancel) {}
            }
            .onChange(of: viewModel.savedSuccessfully) {
                if viewModel.savedSuccessfully { dismiss() }
            }
            .onChange(of: viewModel.deletedSuccessfully) {
                if viewModel.deletedSuccessfully { dismiss() }
            }
            .task {
                await viewModel.fetchExistingReview(mediaId: mediaId)
            }
        }
    }
}
