//
//  BreedDetailScreen.swift
//  CatApp
//
//  Created by Lucas Cardinali on 8/10/24.
//

import SwiftUI

struct BreedDetailScreen: View {

    private let breed: Breed

    init(breed: Breed) {
        self.breed = breed
    }

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
            } label: {
                Image(systemName: "star")
            }
        }
        .navigationTitle(breed.name)
    }
}

#Preview {
    NavigationStack {
        BreedDetailScreen(breed: Breed.mock())
    }
}
