//
//  AppTabs.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct AppTabs: View {
    var body: some View {
        TabView {
            Tab("Breeds", systemImage: "cat.fill") {
                NavigationStack {
                    CatListScreen()
                }
            }
            Tab("Favorites", systemImage: "star") {
                NavigationStack {
                    FavoriteScreen(cats: [])
                }
            }
            .badge(2)
        }
    }
}

#Preview {
    AppTabs()
}
