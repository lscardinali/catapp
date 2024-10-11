//
//  AppTabs.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftUI

struct AppTabs: View {

    struct AccessibilityIdentifiers {
        static let breedsTab = "BreedsTab"
        static let favoritesTab = "FavoritesTab"
    }

    let breedsTabTitle = "Breed"
    let favoritesTabTitle = "Favorites"

    let breedsTabImage = "cat.fill"
    let favoritesTabImage = "star"

    @Bindable var store: StoreOf<Breeds>

    var body: some View {

        TabView {
            Tab(breedsTabTitle, systemImage: breedsTabImage) {
                NavigationStack {
                    BreedListScreen(store: store)
                }
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.breedsTab)
            Tab(favoritesTabTitle, systemImage: favoritesTabImage) {
                NavigationStack {
                    FavoriteScreen(store: store)
                }
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.favoritesTab)
            .badge(store.favoriteBreeds.count)
        }
    }
}

#Preview {
    AppTabs(
        store: Store(initialState: Breeds.State()) {
            Breeds()
        })
}
