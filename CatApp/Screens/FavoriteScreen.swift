//
//  FavoriteScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI
import SwiftData

struct FavoriteScreen: View {

    @Query private var favorites: [Breed]


    var body: some View {

        Group {
            if favorites.isEmpty {
                Text("No breeds added to favorites")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    BreedGridView(breeds: favorites, onTileAppear: nil)
                        .padding()
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview("Filled State") {
    NavigationStack {
        FavoriteScreen()
            .modelContainer(for: Breed.self, inMemory: true)

    }
}

#Preview("Empty State") {
    NavigationStack {
        FavoriteScreen()
            .modelContainer(for: Breed.self, inMemory: true)

    }
}
