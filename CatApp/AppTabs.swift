//
//  AppTabs.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftUI

struct AppTabs: View {

    private var store: StoreOf<Breeds>

    init(store: StoreOf<Breeds>) {

        self.store = store
    }

    var body: some View {
        TabView {
            Tab("Breeds", systemImage: "cat.fill") {
                NavigationStack {
                    BreedListScreen(
                        store: store)
                }
            }
            Tab("Favorites", systemImage: "star") {
                NavigationStack {
                    FavoriteScreen()
                }
            }
            .badge(2)
        }
    }
}

#Preview {
    AppTabs(store: Store(initialState: Breeds.State()) {
        Breeds()
    })
}
