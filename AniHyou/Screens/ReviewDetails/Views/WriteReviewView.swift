//
//  WriteReviewView.swift
//  AniHyou
//

import SwiftUI
import AniListAPI

struct WriteReviewView: View {
    @Environment(\.dismiss) private var dismiss

    let mediaId: Int
    var existingReview: UserMediaReviewQuery.Data.Review?

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
                    HStack {
                        TextField("0", value: $viewModel.score, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: textFieldWidth)
                        Stepper(
                            "/100",
                            value: $viewModel.score,
                            in: 0...100
                        )
                    }
                }

                Section {
                    Toggle("Private", isOn: $viewModel.isPrivate)
                }

                if let id = existingReview?.id {
                    Button("Delete Review", role: .destructive) {
                        showDeleteDialog = true
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
            .navigationTitle(existingReview == nil ? "Write Review" : "Edit Review")
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
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        let action: () -> Void = {
                            Task { await viewModel.save(id: existingReview?.id, mediaId: mediaId) }
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
            .onAppear {
                if let review = existingReview {
                    viewModel.summary = review.summary ?? ""
                    viewModel.body = review.body ?? ""
                    viewModel.score = review.score ?? 0
                    viewModel.isPrivate = review.private ?? false
                }
            }
        }
    }
}
