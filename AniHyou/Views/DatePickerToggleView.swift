//
//  DatePickerToggleView.swift
//  AniHyou
//
//  Created by Axel Lopez on 22/6/22.
//

import SwiftUI

struct DatePickerToggleView: View {

    let text: LocalizedStringKey
    let systemImage: String
    @Binding var selection: Date
    @Binding var isDateSet: Bool
    @State private var showDatePicker = false

    var body: some View {
        VStack {
            Button {
                if isDateSet {
                    showDatePicker.toggle()
                }
            } label: {
                Label {
                    Toggle(isOn: $isDateSet) {
                        Text(text)
                        if isDateSet {
                            Text("\(selection.formatted(date: .abbreviated, time: .omitted))")
                                .font(.footnote)
                                .foregroundStyle(.tint)
                        }
                    }
                } icon: {
                    Image(systemName: systemImage)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
            .onChange(of: isDateSet) {
                showDatePicker = isDateSet
            }
            if showDatePicker {
                DatePicker("Start Date", selection: $selection, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
            }
        }
    }
}

#Preview {
    DatePickerToggleView(
        text: "Start Date",
        systemImage: "calendar",
        selection: .constant(Date()),
        isDateSet: .constant(true)
    )
}
