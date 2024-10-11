//
//  CatTileView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftUI

struct BreedTileView: View {

    struct AccessibilityIdentifiers {
        static let favoriteButton = "FavoriteButton"
        static let breedTileName = "BreedTileName"
    }

    let favoriteImage = "star.fill"
    let unfavoriteImage = "star"

    let lifeSpanSeparator = " - "

    @Bindable var store: StoreOf<Breeds>

    private let breed: Breed

    let showLifeExpectancy: Bool

    init(store: StoreOf<Breeds>, breed: Breed, showLifeExpectancy: Bool = false) {
        self.store = store
        self.breed = breed
        self.showLifeExpectancy = showLifeExpectancy
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
                        BreedPlaceholderView()
                    }
                } else {
                    BreedPlaceholderView()
                }

                VStack {
                    Button {
                        store.send(.toggleFavorite(breed))
                    } label: {
                        Image(systemName: breed.favorite ? favoriteImage : unfavoriteImage)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.favoriteButton)

                    Spacer()

                    if showLifeExpectancy,
                        let lifeSpan = breed.lifeSpan?.split(separator: lifeSpanSeparator).first {
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
                .accessibilityIdentifier(AccessibilityIdentifiers.breedTileName)
        }
    }
}

#Preview("Default", traits: .sizeThatFitsLayout) {
    BreedTileView(
        store: Store(
            initialState: Breeds.State(),
            reducer: {
                Breeds()
            }), breed: Breed.mock())
}

#Preview("With Life Expectancy", traits: .sizeThatFitsLayout) {
    BreedTileView(
        store: Store(
            initialState: Breeds.State(),
            reducer: {
                Breeds()
            }), breed: Breed.mock(), showLifeExpectancy: true)
}
