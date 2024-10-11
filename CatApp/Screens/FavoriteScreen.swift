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

    @Bindable var store: StoreOf<Breeds>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in

            Group {
                if viewStore.favoriteBreeds.isEmpty {
                    Text("No breeds added to favorites")
                        .foregroundStyle(.secondary)
                } else {
                    ScrollView {
                        BreedGridView(store: store, showOnlyFavorites: true, showLifeExpectancy: true)
                            .padding()
                    }
                }
            }
            .navigationTitle("Favorites")

        }
    }
}

#Preview("Filled State") {
    NavigationStack {
        FavoriteScreen(
            store: Store(
                initialState: Breeds.State(),
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
