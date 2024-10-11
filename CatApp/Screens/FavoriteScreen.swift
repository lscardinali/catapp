//
//  FavoriteScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftData
import SwiftUI

struct FavoriteScreen: View {

    struct AccessibilityIdentifiers {
        static let noFavoritesText = "noFavoritesText"
    }

    let noFavoritesLabel = "No breeds added to favorites"
    let navigationTitle = "Favorites"

    @Bindable var store: StoreOf<Breeds>

    var body: some View {
        WithViewStore(
            store, observe: { $0 },
            content: { viewStore in

                Group {
                    if viewStore.favoriteBreeds.isEmpty {
                        Text(noFavoritesLabel)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier(AccessibilityIdentifiers.noFavoritesText)
                    } else {
                        ScrollView {
                            BreedGridView(store: store, showOnlyFavorites: true, showLifeExpectancy: true)
                                .padding()
                        }
                    }
                }
                .navigationTitle(navigationTitle)

            })
    }
}

#Preview("Filled State") {
    NavigationStack {
        FavoriteScreen(
            store: Store(
                initialState: Breeds.State(
                    breeds: [
                        Breed(id: "a", name: "Siamese", favorite: true)
                    ]
                ),
                reducer: {
                    Breeds()
                }))

    }
}

#Preview("Empty State") {
    NavigationStack {
        FavoriteScreen(
            store: Store(
                initialState: Breeds.State(),
                reducer: {
                    Breeds()
                }))

    }
}
