//
//  Breeds.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct Breeds {
    
    @Dependency(\.catApiClient) var apiClient

    @ObservableState
    struct State: Equatable {
        var page: Int = 0
        var breedFilterText: String = ""
        var breedsRequestInFlight: Bool = false
        var hasMoreBreedsToLoad: Bool = true
        var breeds: [Breed] = []
    }

    enum Action {
        case fetchMoreBreeds
        case breedsResponse(Result<[Breed], any Error>)
        case setFavorite(Breed)
        case filterTextChange(String)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchMoreBreeds:
                state.breedsRequestInFlight = true
                return .run { [page = state.page] send in
                    await send(.breedsResponse(Result { try await apiClient.breeds(page, 10)}))
                }

            case .filterTextChange(let text):
                state.breedFilterText = text
                 return .none

            case .setFavorite(let breed):
                breed.favorite = !breed.favorite
                return .none

            case .breedsResponse(.failure):
                return .none

            case let .breedsResponse(.success(breeds)):
                if breeds.isEmpty {
                    state.hasMoreBreedsToLoad = false
                } else {
                    state.page += 1
                    state.breeds.append(contentsOf: breeds)
                }
                state.breedsRequestInFlight = false
                return .none

            }
        }
    }
}
