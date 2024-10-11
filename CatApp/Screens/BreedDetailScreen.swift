//
//  BreedDetailScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 8/10/24.
//

import ComposableArchitecture
import SwiftUI

struct BreedDetailScreen: View {

    struct AccessibilityIdentifiers {
        static let breedDetailImage = "BreedDetailImage"
    }

    let breed: Breed

    let favoriteImage = "star.fill"
    let unfavoriteImage = "star"

    let sectionTitle = "Info"
    let originLabel = "Origin"
    let temperamentLabel = "Temperament"
    let descriptionLabel = "Description"

    let detailImageHeight = CGFloat(200)

    @Bindable var store: StoreOf<Breeds>

    var body: some View {
        List {

            if let imageUrl = URL(string: breed.image ?? "") {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: detailImageHeight)
                } placeholder: {
                    BreedPlaceholderView()
                }
                .listRowInsets(EdgeInsets())
                .accessibilityIdentifier(AccessibilityIdentifiers.breedDetailImage)
            } else {
                BreedPlaceholderView()
                    .accessibilityIdentifier(AccessibilityIdentifiers.breedDetailImage)
            }

            Section(sectionTitle) {
                if let origin = breed.origin {
                    HStack {
                        Text(originLabel)
                        Spacer()
                        Text(origin)
                            .foregroundStyle(.secondary)
                    }
                }
                if let temperament = breed.temperament {
                    VStack(alignment: .leading) {
                        Text(temperamentLabel)
                        Text(temperament)
                            .foregroundStyle(.secondary)
                    }
                }
                if let description = breed.desc {
                    VStack(alignment: .leading) {
                        Text(descriptionLabel)
                        Text(description)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .toolbar {
            Button {
                store.send(.toggleFavorite(breed))
            } label: {
                Image(systemName: breed.favorite ? favoriteImage : unfavoriteImage)
            }
        }
        .navigationTitle(breed.name)
    }
}

#Preview {
    NavigationStack {
        BreedDetailScreen(
            breed: Breed.mock(),
            store: Store(
                initialState: Breeds.State(),
                reducer: {
                    Breeds()
                }))
    }
}
