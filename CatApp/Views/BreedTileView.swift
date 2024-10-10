//
//  CatTileView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct BreedTileView: View {

    private let breed: Breed

    init(breed: Breed) {
        self.breed = breed
    }

    @ViewBuilder
    func placeholderImageView(size: CGSize = CGSize(width: 100, height: 50), foregroundColor: Color = .gray)
        -> some View
    {
        ZStack {
            Color.lightGray
            Image(systemName: "cat")
                .resizable()
                .scaledToFit()
                .padding(16)
                .foregroundStyle(.white)
        }
        .frame(width: 100, height: 100)
        .cornerRadius(10)
    }

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {

                if let imageUrl = URL(string: breed.image ?? "") {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    } placeholder: {
                        placeholderImageView()
                    }
                } else {
                    placeholderImageView()
                }

                Button {
                    
                } label: {
                    Image(systemName: breed.favorite ? "star.fill" : "star")
                }
                .padding(8)

            }
            Text(breed.name)
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
    }
}

#Preview {
    BreedTileView(breed: Breed.mock())
}
