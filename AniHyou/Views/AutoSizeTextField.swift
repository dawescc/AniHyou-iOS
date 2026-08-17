//
//  AutoSizeTextField.swift
//  AniHyou
//
//  Created by Axel on 17/08/2026.
//

import SwiftUI

struct AutoSizeTextField<V>: View {
    
    @Binding var value: V
    let placeholder: String
    let trailingText: LocalizedStringKey
    let minWidth: CGFloat = 0
    let formatter: Formatter
    
    @State private var frame = CGRect.zero

    var body: some View {
        HStack {
            ZStack {
                Text(formatter.string(for: value) ?? placeholder)
                    .foregroundColor(Color.clear)
                    .fixedSize()
                    .background(rectReader($frame))

                TextField(placeholder, value: $value, formatter: formatter)
                    .frame(minWidth: minWidth, idealWidth: max(frame.width, minWidth))
                    .fixedSize(horizontal: true, vertical: false)
            }

            Text(trailingText)
                .foregroundStyle(.secondary)
        }
    }
    
    private func rectReader(_ binding: Binding<CGRect>, _ space: CoordinateSpace = .global) -> some View {
        GeometryReader { (geometry) -> Color in
            let rect = geometry.frame(in: space)
            DispatchQueue.main.async {
                binding.wrappedValue = rect
            }
            return .clear
        }
    }
}
