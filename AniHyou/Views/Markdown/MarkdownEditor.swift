//
//  MarkdownEditor.swift
//  AniHyou
//
//  Created by Axel on 13/08/2026.
//

import SwiftUI

struct MarkdownEditor: View {
    
    @Namespace private var unionNamespace
    
    @Binding var text: String
    @State private var selection: TextSelection?
    
    @State private var lastFormat: MarkdownFormat?
    @State private var showingLinkAlert = false
    @State private var linkText = ""
    
    @FocusState private var textEditorFocus: Bool
    
    var body: some View {
        VStack {
            TextEditor(text: $text, selection: $selection)
                .padding()
                .focused($textEditorFocus)
        }
        .alert(lastFormat?.localizedName ?? "Link", isPresented: $showingLinkAlert) {
            TextField("Paste your link here", text: $linkText)
            Button("OK") {
                if let lastFormat {
                    insertLinkFormat(lastFormat, link: linkText)
                    linkText = ""
                }
            }
            Button("Cancel", role: .cancel) { linkText = "" }
        }
        .safeAreaInset(edge: .bottom) {
            if #available(iOS 26.0, *) {
                bottomToolbarGlass
            } else {
                bottomToolbar
            }
        }
        .onAppear {
            textEditorFocus = true
        }
    }
    
    @available(iOS 26.0, *)
    private var bottomToolbarGlass: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GlassEffectContainer(spacing: 0) {
                HStack {
                    ForEach(MarkdownFormat.allCases) { format in
                        Button(action: { insertFormat(format) }) {
                            Image(systemName: format.systemImage)
                                .font(.system(size: 22))
                                .frame(width: 30, height: 30)
                                .scaledToFit()
                        }
                        .labelStyle(.iconOnly)
                        .buttonStyle(.glass)
                        .tint(nil)
                        .glassEffectUnion(id: "1", namespace: unionNamespace)
                    }
                }
            }
            .scrollTargetLayout()
            .padding(.vertical, 4)
        }
        .contentMargins(.horizontal, 20)
    }
    
    private var bottomToolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(MarkdownFormat.allCases) { format in
                    Button(action: { insertFormat(format) }) {
                        Image(systemName: format.systemImage)
                            .font(.system(size: 22))
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                    .padding(.horizontal, 4)
                }
            }
            .scrollTargetLayout()
            .padding(.vertical, 4)
        }
        .contentMargins(.horizontal, 20)
    }
    
    private func insertFormat(_ format: MarkdownFormat) {
        lastFormat = format
        switch format {
        case .link, .image, .video, .youtube:
            showingLinkAlert = true
        default:
            let newText = text + format.syntax
            let index = newText.index(
                newText.startIndex,
                offsetBy: newText.count - format.selectionOffset
            )
            text = newText
            selection = TextSelection(insertionPoint: index)
        }
    }
    
    private func insertLinkFormat(_ format: MarkdownFormat, link: String) {
        let newText = text + String(format: format.syntax, link)
        let index = newText.index(
            newText.startIndex,
            offsetBy: newText.count - format.selectionOffset
        )
        text = newText
        selection = TextSelection(insertionPoint: index)
    }
}

#Preview {
    @Previewable @State var text = ""
    MarkdownEditor(text: $text)
}
