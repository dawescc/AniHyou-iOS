//
//  MediaListEditView.swift
//  AniHyou
//
//  Created by Axel Lopez on 20/6/22.
//

import SwiftUI
import AniListAPI

// swiftlint:disable:next type_body_length
struct MediaListEditView: View {
    @Environment(\.dismiss) private var dismiss

    let mediaDetails: BasicMediaDetails?
    var mediaList: BasicMediaListEntry?
    var onSave: (_ updatedEntry: BasicMediaListEntry) async -> Void = { _ in }
    var onDelete: () async -> Void = {}

    @State private var viewModel = MediaListEditViewModel()
    @State private var showDeleteDialog = false
    
    @AppStorage(ADVANCED_SCORING_ENABLED_KEY) private var advancedScoringEnabled: Bool?
    @AppStorage(SCORE_STEPS) private var scoreSteps: Double = 1

    @State private var status: MediaListStatus = .planning
    @State private var progress: Int?
    @State private var progressVolumes: Int?
    @State private var repeatCount: Int?
    @State private var startDate = Date()
    @State private var isStartDateSet = false
    @State private var finishDate = Date()
    @State private var isFinishDateSet = false
    @State private var showStartDate = false
    @State private var showFinishDate = false
    @State private var isPrivate = false
    @State private var isHiddenFromStatusLists = false
    @State private var notes = ""
    @State private var showWriteReview = false
    @State private var advancedScores: [String: Double] = [:]
    @State private var customLists: [String: Bool] = [:]
    @State private var priority = 0

    private let textFieldWidth: CGFloat = 65
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    var body: some View {
        NavigationStack {
            Form {
                Label {
                    Picker("Status", selection: $status) {
                        ForEach(MediaListStatus.allCases, id: \.self) { status in
                            Label(status.localizedName, systemImage: status.systemImage)
                        }
                    }
                    .labelStyle(.titleOnly)
                } icon: {
                    Image(systemName: status.systemImage)
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(.primary)
                .onChange(of: status) {
                    if status == .completed {
                        progress = mediaDetails?.maxEpOrCh ?? progress
                        progressVolumes = mediaDetails?.volumes ?? progressVolumes
                        if !isFinishDateSet {
                            finishDate = .now
                            isFinishDateSet = true
                        }
                    } else if status == .current && !isStartDateSet {
                        startDate = .now
                        isStartDateSet = true
                    }
                }

                scoreSection
                
                progressSection

                Section("Dates") {
                    DatePickerToggleView(
                        text: "Start Date",
                        systemImage: "calendar",
                        selection: $startDate,
                        isDateSet: $isStartDateSet
                    )
                    DatePickerToggleView(
                        text: "Finish Date",
                        systemImage: "calendar.badge.checkmark",
                        selection: $finishDate,
                        isDateSet: $isFinishDateSet
                    )
                }
                
                Section {
                    NavigationLink(destination: MediaCustomListsView(customLists: $customLists)) {
                        Label {
                            Text("Custom lists")
                        } icon: {
                            Image(systemName: "list.bullet")
                                .foregroundStyle(.secondary)
                        }
                        .foregroundStyle(.primary)
                    }
                }
                
                Section("Priority") {
                    Label {
                        Stepper(priority.priorityName, value: $priority, in: 0...2)
                    } icon: {
                        Image(systemName: "exclamationmark")
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                }

                Section {
                    Label {
                        Toggle("Hide from status lists", isOn: $isHiddenFromStatusLists)
                    } icon: {
                        Image(systemName: isHiddenFromStatusLists ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                    Label {
                        Toggle("Private", isOn: $isPrivate)
                    } icon: {
                        Image(systemName: isPrivate ? "lock" : "lock.open")
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                }

                Section {
                    Label {
                        TextField("Notes", text: $notes, axis: .vertical)
                            .lineLimit(5)
                    } icon: {
                        Image(systemName: "text.justify.left")
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.primary)
                    Button("Write a Review", systemImage: "pencil") {
                        showWriteReview = true
                    }
                }
                
                if advancedScoringEnabled == true {
                    advancedScoresView
                }

                Button(role: .destructive) {
                    showDeleteDialog = true
                } label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundStyle(.red)
                }
                .disabled(mediaList == nil)
                .confirmationDialog("Delete this entry?", isPresented: $showDeleteDialog) {
                    Button("Delete", role: .destructive) {
                        Task {
                            await viewModel.deleteEntry()
                        }
                    }
                } message: {
                    Text("Delete this entry?")
                }
            }//:Form
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
        }//:NavigationStack
        .sheet(isPresented: $showWriteReview) {
            if let id = mediaDetails?.id {
                WriteReviewView(mediaId: id)
            }
        }
        .onAppear {
            setValues()
        }
        .onChange(of: viewModel.isUpdateSuccess) {
            if viewModel.isUpdateSuccess, let entry = viewModel.entry {
                Task {
                    await onSave(entry)
                    dismiss()
                }
            }
        }
        .onChange(of: viewModel.isDeleteSuccess) {
            if viewModel.isDeleteSuccess {
                Task {
                    await onDelete()
                    dismiss()
                }
            }
        }
    }
    
    @ViewBuilder
    private var scoreSection: some View {
        Section("Score") {
            switch viewModel.scoreFormat {
            case .point5:
                HStack {
                    Spacer()
                    StarRatingView(rating: $viewModel.score)
                    Spacer()
                }
            case .point3:
                HStack {
                    Spacer()
                    SmileyRatingView(rating: $viewModel.score)
                    Spacer()
                }
            default:
                Label {
                    Stepper(
                        onIncrement: {
                            if (viewModel.score ?? 0) < viewModel.scoreMax {
                                if viewModel.score == nil {
                                    viewModel.score = scoreSteps
                                } else {
                                    viewModel.score! += scoreSteps
                                }
                            }
                        },
                        onDecrement: {
                            if viewModel.score != nil && viewModel.score! > 0 {
                                if (viewModel.score! - scoreSteps) <= 0 {
                                    viewModel.score = nil
                                } else {
                                    viewModel.score! -= scoreSteps
                                }
                            }
                        }
                    ) {
                        AutoSizeTextField(
                            value: $viewModel.score,
                            placeholder: "0",
                            trailingText: "/\(viewModel.scoreHint)",
                            formatter: decimalFormatter
                        )
                        .keyboardType(.decimalPad)
                    }
                } icon: {
                    Image(systemName: "star")
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(.primary)
            }
        }
    }
    
    @ViewBuilder
    private var progressSection: some View {
        Section("Progress") {
            Label {
                Stepper(
                    onIncrement: {
                        let maxValue = mediaDetails?.maxEpOrCh
                        if maxValue == nil || (progress ?? 0) < maxValue! {
                            if progress == nil {
                                progress = 1
                            } else {
                                progress! += 1
                            }
                        }
                    },
                    onDecrement: {
                        if progress != nil && progress! > 0 {
                            if progress == 1 {
                                progress = nil
                            } else {
                                progress! -= 1
                            }
                        }
                    }
                ) {
                    AutoSizeTextField(
                        value: $progress,
                        placeholder: "0",
                        trailingText: mediaDetails?.type == .anime ? "Episodes" : "Chapters",
                        formatter: NumberFormatter()
                    )
                    .keyboardType(.numberPad)
                }
                .onChange(of: progress) {
                    if let max = mediaDetails?.maxEpOrCh, (progress ?? 0) > max {
                        progress = max
                    }
                }
            } icon: {
                Image(systemName: mediaDetails?.type == .anime ? "play.rectangle.on.rectangle" : "book.pages")
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(.primary)
            .onChange(of: progress) {
                if status == .planning || mediaList == nil {
                    onUpdatedFromPlanning()
                }
                if let maxProgress = mediaDetails?.maxEpOrCh,
                   (progress ?? 0) >= maxProgress
                {
                    onMaxProgressReached()
                }
            }
            if mediaDetails?.type == .manga {
                Label {
                    Stepper(
                        onIncrement: {
                            let maxValue = mediaDetails?.volumes
                            if maxValue == nil || (progressVolumes ?? 0) < maxValue! {
                                if progressVolumes == nil {
                                    progressVolumes = 1
                                } else {
                                    progressVolumes! += 1
                                }
                            }
                        },
                        onDecrement: {
                            if progressVolumes != nil && progressVolumes! > 0 {
                                if progressVolumes == 1 {
                                    progressVolumes = nil
                                } else {
                                    progressVolumes! -= 1
                                }
                            }
                        }
                    ) {
                        AutoSizeTextField(
                            value: $progressVolumes,
                            placeholder: "0",
                            trailingText: "Volumes",
                            formatter: NumberFormatter()
                        )
                        .keyboardType(.numberPad)
                    }
                    .onChange(of: progressVolumes) {
                        if let max = mediaDetails?.volumes, (progressVolumes ?? 0) > max {
                            progressVolumes = max
                        }
                    }
                } icon: {
                    Image(systemName: "bookmark")
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(.primary)
                .onChange(of: progressVolumes) {
                    if status == .planning || mediaList == nil {
                        onUpdatedFromPlanning()
                    }
                    if let maxVolumes = mediaDetails?.volumes,
                       (progressVolumes ?? 0) >= maxVolumes
                    {
                        onMaxProgressReached()
                    }
                }
            }
        }

        Section {
            Label {
                Stepper(
                    onIncrement: {
                        if repeatCount == nil {
                            repeatCount = 1
                        } else {
                            repeatCount! += 1
                        }
                    },
                    onDecrement: {
                        if repeatCount != nil && repeatCount! > 0 {
                            if repeatCount == 1 {
                                repeatCount = nil
                            } else {
                                repeatCount! -= 1
                            }
                        }
                    }
                ) {
                    AutoSizeTextField(
                        value: $repeatCount,
                        placeholder: "0",
                        trailingText: "Repeat Count",
                        formatter: NumberFormatter()
                    )
                    .keyboardType(.numberPad)
                }
            } icon: {
                Image(systemName: "repeat")
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(.primary)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
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

        ToolbarItem(placement: .confirmationAction) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                let action: () -> Void = {
                    Task {
                        await viewModel.updateEntry(
                            mediaId: mediaDetails!.id,
                            status: status,
                            score: viewModel.score,
                            advancedScoresDict: advancedScores,
                            progress: progress,
                            progressVolumes: progressVolumes,
                            startedAt: isStartDateSet ? startDate : nil,
                            completedAt: isFinishDateSet ? finishDate : nil,
                            repeatCount: repeatCount,
                            isPrivate: isPrivate,
                            isHiddenFromStatusLists: isHiddenFromStatusLists,
                            customLists: customLists,
                            notes: notes,
                            priority: priority
                        )
                    }
                }
                if #available(iOS 26, *) {
                    Button(action: action) {
                        Label("Save", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("Save", action: action)
                        .font(.bold(.body)())
                }
            }
        }
    }
    
    @ViewBuilder
    private var advancedScoresView: some View {
        ForEach(advancedScores.keys.sorted(), id: \.self) { name in
            Section(name) {
                let value = Binding(
                    get: { advancedScores[name] ?? 0 },
                    set: { advancedScores[name] = $0 }
                )
                Stepper(
                    value: value,
                    in: 0...viewModel.scoreMax,
                    step: scoreSteps
                ) {
                    AutoSizeTextField(
                        value: value,
                        placeholder: "0",
                        trailingText: "/\(viewModel.scoreHint)",
                        formatter: decimalFormatter
                    )
                    .keyboardType(.decimalPad)
                }
                .foregroundStyle(.primary)
            }
        }
    }
    
    private func onMaxProgressReached() {
        status = .completed
        if !isFinishDateSet {
            finishDate = .now
            isFinishDateSet = true
        }
    }
    
    private func onUpdatedFromPlanning() {
        status = .current
        if !isStartDateSet {
            startDate = .now
            isStartDateSet = true
        }
    }

    private func setValues() {
        viewModel.entry = self.mediaList
        self.status = self.mediaList?.status?.value ?? .planning
        self.progress = self.mediaList?.progress.greaterThanZeroOrNil()
        self.progressVolumes = self.mediaList?.progressVolumes.greaterThanZeroOrNil()
        self.repeatCount = self.mediaList?.repeat.greaterThanZeroOrNil()
        viewModel.score = self.mediaList?.score.greaterThanZeroOrNil()
        if let startedYear = self.mediaList?.startedAt?.year {
            if let startedMonth = self.mediaList?.startedAt?.month {
                if let startedDay = self.mediaList?.startedAt?.day {
                    if let startDate = date(year: startedYear, month: startedMonth, day: startedDay) {
                        self.startDate = startDate
                    }
                }
            }
        }
        self.isStartDateSet = self.mediaList?.startedAt?.year != nil

        if let completedYear = self.mediaList?.completedAt?.year {
            if let completedMonth = self.mediaList?.completedAt?.month {
                if let completedDay = self.mediaList?.completedAt?.day {
                    if let finishDate = date(year: completedYear, month: completedMonth, day: completedDay) {
                        self.finishDate = finishDate
                    }
                }
            }
        }
        self.isFinishDateSet = self.mediaList?.completedAt?.year != nil

        self.isPrivate = self.mediaList?.private ?? false
        self.isHiddenFromStatusLists = self.mediaList?.hiddenFromStatusLists ?? false
        self.notes = self.mediaList?.notes ?? ""
        self.advancedScores = self.mediaList?.advancedScoresDict ?? [:]
        if let customListsDict = self.mediaList?.customListsDict {
            self.customLists = customListsDict
        } else { // new entry, use custom list from settings
            if let customListsKey = mediaDetails?.type?.value?.customListsKey {
                UserDefaults.standard.stringArray(
                    forKey: customListsKey
                )?.forEach { name in
                    self.customLists[name] = false
                }
            }
        }
        self.priority = self.mediaList?.priority ?? 0
    }
}

#Preview {
    MediaListEditView(mediaDetails: nil)
// swiftlint:disable:next file_length
}
