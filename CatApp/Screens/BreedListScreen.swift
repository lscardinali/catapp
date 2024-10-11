//
//  CatListScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI
import ComposableArchitecture

struct BreedListScreen: View {

    @Bindable var store: StoreOf<Breeds>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                BreedGridView(store: store, showOnlyFavorites: false)
                    .padding()

                if viewStore.breedsRequestInFlight {
                    ProgressView()
                }

            }
            .alert("Error when loading data", isPresented: viewStore.binding(get: { $0.hasError }, send: .dismissError)) {
                Button("OK", role: .cancel) { }
            }
            .onAppear {
                store.send(.fetchLocalBreeds)
            }
            .navigationTitle("Breeds")
            .searchable(text: $store.breedFilterText.sending(\.filterTextChange), prompt: "Search By Breed")

        }
    }

}

#Preview {
    NavigationStack {
        BreedListScreen(store: Store(initialState: Breeds.State(), reducer: {
            Breeds()
        }))
    }
}
