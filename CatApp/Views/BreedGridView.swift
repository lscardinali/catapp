//
//  CatGridView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct BreedGridView: View {

    let breeds: [Breed]

    let onTileAppear: ((Breed) -> Void)?


    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(breeds) { breed in
                NavigationLink {
                    BreedDetailScreen(breed: breed)
                } label: {
                    BreedTileView(breed: breed)
                        .onAppear {
                            onTileAppear?(breed)
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    BreedGridView(breeds: [Breed.mock()], onTileAppear: nil)
}
