//
//  CatGridView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct CatGridView: View {

    let breeds: [Breed]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(breeds) { breed in
                NavigationLink {
                    BreedDetailScreen(breed: breed)
                } label: {
                    CatTileView(cat: breed)
                }
            }
        }
    }
}

#Preview {
    CatGridView(breeds: [Breed.mock()])
}
