//
//  BreedDetailScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 8/10/24.
//

import SwiftUI
import ComposableArchitecture

struct BreedDetailScreen: View {

    let breed: Breed

    @Bindable var store: StoreOf<Breeds>

    var body: some View {
        List {
            Image("cat")
                .resizable()
                .scaledToFill()
                .listRowInsets(EdgeInsets())
                .frame(height: 200)

            Section("Info") {
                if let origin = breed.origin {
                    HStack {
                        Text("Origin")
                        Spacer()
                        Text(origin)
                            .foregroundStyle(.secondary)
                    }
                }
                if let temperament = breed.temperament {
                    VStack(alignment: .leading) {
                        Text("Temperament")
                        Text(temperament)
                            .foregroundStyle(.secondary)
                    }
                }
                if let description = breed.desc {
                    VStack(alignment: .leading) {
                        Text("Description")
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
                Image(systemName: breed.favorite ? "star.fill" : "star")
            }
        }
        .navigationTitle(breed.name)
    }
}

#Preview {
    NavigationStack {
        BreedDetailScreen(breed: Breed.mock(), store: Store(initialState: Breeds.State(), reducer: {
            Breeds()
        }))
    }
}
