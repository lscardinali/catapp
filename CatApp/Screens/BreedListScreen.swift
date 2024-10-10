//
//  CatListScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI
import ComposableArchitecture

struct BreedListScreen: View {

    @Bindable private var store: StoreOf<Breeds>

    init(store: StoreOf<Breeds>) {
        self.store = store
    }

    var body: some View {
        ScrollView {
            BreedGridView(breeds: store.breeds, onTileAppear: { breed in
                if breed.id == store.breeds.last?.id {
                    store.send(.fetchMoreBreeds)
                }
            }).padding()

                if store.breedsRequestInFlight {
                    ProgressView()
                }

            }
        .onAppear {
            store.send(.fetchMoreBreeds)
        }
        .navigationTitle("Breeds")
        .searchable(text: $store.breedFilterText.sending(\.filterTextChange), prompt: "Search By Breed")

        }

}

#Preview {
    NavigationStack {
        BreedListScreen(store: Store(initialState: Breeds.State(), reducer: {
            Breeds()
        }))
    }
}
