//
//  CatListScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftUI

struct BreedListScreen: View {

    struct AccessibilityIdentifiers {
        static let breedList = "BreedList"
    }

    let errorText = "Error when loading data"
    let okButtonText = "OK"
    let navigationTitle = "Breeds"
    let searchPrompt = "Search for a breed"

    @Bindable var store: StoreOf<Breeds>

    var body: some View {
        WithViewStore(
            store, observe: { $0 },
            content: { viewStore in
                ScrollView {
                    BreedGridView(store: store, showOnlyFavorites: false)
                        .padding()

                    if viewStore.breedsRequestInFlight {
                        ProgressView()
                    }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.breedList)
                .alert(errorText, isPresented: viewStore.binding(get: { $0.hasError }, send: .dismissError)) {
                    Button(okButtonText, role: .cancel) {}
                }
                .onAppear {
                    store.send(.fetchLocalBreeds)
                }
                .navigationTitle(navigationTitle)
                .searchable(text: $store.breedFilterText.sending(\.filterTextChange), prompt: searchPrompt)

            })
    }

}

#Preview {
    NavigationStack {
        BreedListScreen(
            store: Store(
                initialState: Breeds.State(),
                reducer: {
                    Breeds()
                }))
    }
}
