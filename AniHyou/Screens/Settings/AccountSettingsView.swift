//
//  AccountSettingsView.swift
//  AniHyou
//
//  Created by Axel Lopez on 15/10/2023.
//

import SwiftUI
import AniListAPI

struct AccountSettingsView: View {
    
    @Bindable var viewModel: SettingsViewModel
    @State private var showChangesAlert = false
    @State private var showWebView = false
    @AppStorage(SCORE_STEPS) private var scoreSteps: Double = 1
    
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    private let intFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
    
    var body: some View {
        Group {
            if viewModel.areOptionsFetched {
                Form {
                    Section {
                        Picker("Title language", selection: $viewModel.titleLanguage) {
                            ForEach(UserTitleLanguage.allCasesNormal, id: \.self) { lang in
                                Text(lang.localizedName).tag(lang)
                            }
                        }
                        .onChange(of: viewModel.titleLanguage) {
                            viewModel.updateUserOptions(
                                titleLanguage: viewModel.titleLanguage
                            )
                            showChangesAlert = true
                        }
                        Picker("Staff & Character name language", selection: $viewModel.staffNameLanguage) {
                            ForEach(UserStaffNameLanguage.allCases, id: \.self) { lang in
                                Text(lang.localizedName).tag(lang)
                            }
                        }
                        .onChange(of: viewModel.staffNameLanguage) {
                            viewModel.updateUserOptions(
                                staffNameLanguage: viewModel.staffNameLanguage
                            )
                            showChangesAlert = true
                        }
                    } header: {
                        Text("Content")
                    }
                    .alert(
                        "",
                        isPresented: $showChangesAlert,
                        actions: {
                            Button("Close", role: .cancel) {}
                        },
                        message: {
                            Text("Changes will take effect on app restart")
                        }
                    )
                    
                    Section {
                        Picker("Score format", selection: $viewModel.scoreFormat) {
                            ForEach(ScoreFormat.allCases, id: \.self) { format in
                                Text(format.localizedName).tag(format)
                            }
                        }
                        .onChange(of: viewModel.scoreFormat) {
                            viewModel.updateUserOptions(
                                scoreFormat: viewModel.scoreFormat
                            )
                            showChangesAlert = true
                        }
                        if viewModel.scoreFormat == .point10Decimal || viewModel.scoreFormat == .point100 {
                            scoreStepsSettings
                        }
                    } header: {
                        Text("Score")
                    }
                    
                    Section {
                        Toggle("Airing anime notifications", isOn: $viewModel.airingNotifications)
                            .onChange(of: viewModel.airingNotifications) {
                                viewModel.updateUserOptions(
                                    airingNotifications: viewModel.airingNotifications
                                )
                            }
                    } header: {
                        Text("Notifications")
                    }
                    
                    Section {
                        Button("Other account settings") {
                            showWebView = true
                        }
                    } footer: {
                        Text("You may need to login again in your browser")
                    }
                }//:Form
            } else {
                ProgressView()
                    .task {
                        await viewModel.getUserOptions()
                    }
            }
        }//:Group
        .navigationTitle("Account settings")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showWebView) {
            SafariWebView(url: URL(string: "https://anilist.co/settings/account")!)
                .ignoresSafeArea()
        }
    }
    
    private var scoreStepsSettings: some View {
        HStack {
            let formatter = if viewModel.scoreFormat == .point10Decimal {
                decimalFormatter
            } else {
                intFormatter
            }
            TextField("0", value: $scoreSteps, formatter: formatter)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 65)
                .onChange(of: scoreSteps) {
                    if scoreSteps > Double(viewModel.scoreFormat.maxValue) {
                        scoreSteps = Double(viewModel.scoreFormat.maxValue)
                    } else if viewModel.scoreFormat == .point100 {
                        if Int(exactly: scoreSteps) == nil {
                            // point 100 doesn't accept decimals
                            scoreSteps = Double(Int(scoreSteps))
                        }
                    }
                }
            Stepper(
                "Score steps",
                value: $scoreSteps,
                in: 1...Double(viewModel.scoreFormat.maxValue),
                step: 1
            )
        }
    }
}

#Preview {
    AccountSettingsView(viewModel: SettingsViewModel())
}
