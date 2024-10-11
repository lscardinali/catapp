//
//  AppTabs.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftUI

struct AppTabs: View {

    @Bindable var store: StoreOf<Breeds>

    var body: some View {

        TabView {
            Tab("Breeds", systemImage: "cat.fill") {
                NavigationStack {
                    BreedListScreen(store: store)
                }
            }
            Tab("Favorites", systemImage: "star") {
                NavigationStack {
                    FavoriteScreen(store: store)
                }
            }
            .badge(store.favoriteBreeds.count)
        }
    }
}

#Preview {
    AppTabs(store: Store(initialState: Breeds.State()) {
        Breeds()
    })
}
