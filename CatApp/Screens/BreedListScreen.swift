//
//  CatListScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI
import ComposableArchitecture

struct CatListScreen: View {
    @State private var breedTextSearch: String = ""

    private let store: StoreOf<Breeds>

    init(store: StoreOf<Breeds>) {
        self.store = store
    }

    var body: some View {
        ScrollView {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                CatGridView(breeds: viewStore.breeds)
                    .padding()
                Button("Test") {
                    viewStore.send(.fetchMoreBreeds)
                }

            }
        }
        .navigationTitle("Cats")
        .searchable(text: $breedTextSearch, prompt: "Search By Breed")
    }
}

#Preview {
    NavigationStack {
        CatListScreen(store: Store(initialState: Breeds.State(), reducer: {
            Breeds()
        }))
    }
}
