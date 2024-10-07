//
//  CatListScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct CatListScreen: View {
    @State private var breedTextSearch: String = ""

    var body: some View {
        ScrollView {
            CatGridView()
            .padding()
        }
        .navigationTitle("Cats")
        .searchable(text: $breedTextSearch, prompt: "Search By Breed")
    }
}

#Preview {
    NavigationStack {
        CatListScreen()
    }
}
