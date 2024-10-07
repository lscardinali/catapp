//
//  FavoriteScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct FavoriteScreen: View {

    var cats: [Cat]

    var body: some View {

        Group {
            if cats.isEmpty {
                Text("No breeds added to favorites")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    CatGridView()
                        .padding()
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview("Filled State") {
    NavigationStack {
        FavoriteScreen(cats: [Cat(id: 1, name: "Siamese")])
    }
}

#Preview("Empty State") {
    NavigationStack {
        FavoriteScreen(cats: [])
    }
}
