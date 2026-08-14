//
//  ContributorsCredits.swift
//  AniHyou
//
//  Created by Axel on 21/07/2026.
//

import SwiftUI

struct ContributorsCredits: View {
    var body: some View {
        Form {
            Section {
                Link("axiel7", destination: URL(string: "https://github.com/axiel7")!)
                Link("BitForger", destination: URL(string: "https://github.com/BitForger")!)
                Link("alexay7", destination: URL(string: "https://github.com/alexay7")!)
                Link("SquishyLeaf", destination: URL(string: "https://github.com/SquishyLeaf")!)
            }
        }
        .navigationTitle("Contributors")
    }
}

#Preview {
    ContributorsCredits()
}
