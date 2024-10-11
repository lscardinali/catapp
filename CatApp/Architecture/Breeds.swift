//
//  Breeds.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import Foundation
import SwiftData

@Reducer
struct Breeds {

    @Dependency(\.catApiClient) var apiClient
    @Dependency(\.dataPersistenceService) var dataPersistenceService

    @ObservableState
    struct State: Equatable {
        var page: Int = 0
        var breedFilterText: String = ""
        var breedsRequestInFlight: Bool = false
        var hasMoreBreedsToLoad: Bool = true
        var hasError: Bool = false
        var breeds: [Breed] = []
        var favoriteBreeds: [Breed] {
            breeds.filter { $0.favorite }
        }
        var filteredBreeds: [Breed] {
            breedFilterText.isEmpty
                ? breeds : breeds.filter { $0.name.localizedCaseInsensitiveContains(breedFilterText) }
        }
    }

    enum Action {
        case fetchLocalBreeds
        case fetchMoreBreeds
        case breedsResponse(Result<[Breed], any Error>)
        case toggleFavorite(Breed)
        case filterTextChange(String)
        case dismissError
        case displayedBreedCell(Breed)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchLocalBreeds:
                do {
                    let breeds = try dataPersistenceService.loadBreeds()
                    state.breeds = breeds
                } catch {
                    print("Failed fetching Breed data from SwiftData \(error.localizedDescription)")
                }

                return .send(.fetchMoreBreeds)

            case .fetchMoreBreeds:
                state.breedsRequestInFlight = true
                return .run { [page = state.page] send in
                    await send(
                        .breedsResponse(
                            Result { try await apiClient.breeds(page, 10) }
                        ))
                }

            case .filterTextChange(let text):
                state.breedFilterText = text
                return .none

            case .toggleFavorite(let breed):
                breed.favorite = !breed.favorite
                try? dataPersistenceService.updateBreeds()
                return .none

            case .dismissError:
                state.hasError = false
                return .none

            case .breedsResponse(.failure):
                state.hasError = true
                state.breedsRequestInFlight = false
                return .none

            case .breedsResponse(.success(let newBreeds)):
                if newBreeds.isEmpty {
                    state.hasMoreBreedsToLoad = false
                } else {
                    state.page += 1
                    newBreeds.forEach { newBreed in
                        if !state.breeds.contains(where: { $0.id == newBreed.id }) {
                            do {
                                try dataPersistenceService.addBreed(newBreed)
                                state.breeds.append(newBreed)
                            } catch {
                                print("Failed saving Breed data to SwiftData \(error.localizedDescription)")
                            }
                        }
                    }
                }
                state.breedsRequestInFlight = false
                return .none

            case .displayedBreedCell(let breed):
                if let lastBreed = state.breeds.last,
                    breed.id == lastBreed.id,
                    !state.breedsRequestInFlight,
                    state.hasMoreBreedsToLoad {
                    return .send(.fetchMoreBreeds)
                }
                return .none

            }
        }
    }
}
