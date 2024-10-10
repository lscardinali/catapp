//
//  CatAppTests.swift
//  CatAppTests
//
//  Created by Lucas Cardinali on 7/10/24.
//

import Testing
import ComposableArchitecture
@testable import CatApp

struct CatAppTests {

    @Test func example() async throws {

        let store = TestStore(initialState: Breeds.State()) {
            Breeds()
        }


        await store.send(.fetchMoreBreeds)
        await store.receive(\.breedsResponse) {
            $0.page = 1
            $0.breeds.count > 0
        }


    }

}
