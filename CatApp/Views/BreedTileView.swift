//
//  CatTileView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI
import ComposableArchitecture

struct BreedTileView: View {

    @Bindable var store: StoreOf<Breeds>

    private let breed: Breed

    let showLifeExpectancy: Bool

    init(store: StoreOf<Breeds>, breed: Breed, showLifeExpectancy: Bool = false) {
        self.store = store
        self.breed = breed
        self.showLifeExpectancy = showLifeExpectancy
    }

    @ViewBuilder
    func placeholderImageView() -> some View {
        ZStack {
            Color.placeholderForeground
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
            ZStack(alignment: .trailing) {
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

                VStack {
                    Button {
                        store.send(.toggleFavorite(breed))
                    } label: {
                        Image(systemName: breed.favorite ? "star.fill" : "star")
                    }

                    Spacer()

                    if showLifeExpectancy,
                       let lifeSpan = breed.lifeSpan?.split(separator: " - ").first {
                        Text(lifeSpan)
                            .bold()
                    }
                }
                .padding(8)

            }
            .frame(width: 100, height: 100)

            Text(breed.name)
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
    }
}

#Preview("Default", traits: .sizeThatFitsLayout) {
    BreedTileView(store: Store(initialState: Breeds.State(), reducer: {
        Breeds()
    }), breed: Breed.mock())
}

#Preview("With Life Expectancy", traits: .sizeThatFitsLayout) {
    BreedTileView(store: Store(initialState: Breeds.State(), reducer: {
        Breeds()
    }), breed: Breed.mock(), showLifeExpectancy: true)
}
