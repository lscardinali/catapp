//
//  CatGridView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftUI

struct BreedGridView: View {

    @Bindable var store: StoreOf<Breeds>

    let showOnlyFavorites: Bool
    let showLifeExpectancy: Bool

    init(store: StoreOf<Breeds>, showOnlyFavorites: Bool = false, showLifeExpectancy: Bool = false) {
        self.store = store
        self.showOnlyFavorites = showOnlyFavorites
        self.showLifeExpectancy = showLifeExpectancy
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(
                showOnlyFavorites
                    ? store.favoriteBreeds : (store.breedFilterText.isEmpty ? store.breeds : store.filteredBreeds)
            ) { breed in
                NavigationLink {
                    BreedDetailScreen(breed: breed, store: store)
                } label: {
                    BreedTileView(store: store, breed: breed, showLifeExpectancy: showLifeExpectancy)
                        .onAppear {
                            store.send(.displayedBreedCell(breed))
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    BreedGridView(
        store: Store(
            initialState: Breeds.State(
                breeds: [Breed.mock()]
            ),
            reducer: {
                Breeds()
            }), showOnlyFavorites: false)
}
