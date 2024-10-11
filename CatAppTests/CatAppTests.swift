//
//  CatAppTests.swift
//  CatAppTests
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftData
import Testing

@testable import CatApp

@MainActor
struct CatAppTests {

    let firstResponse = (0...3).map { _ in Breed.mock() }
    let secondResponse = (0...3).map { _ in Breed.mock() }

    let filterResponse = [Breed.mock(), Breed.mock(), Breed(id: "abc", name: "Siamese")]

    let sut: TestStoreOf<Breeds>
    let testModelContainer: ModelContainer

    init() {

        // This uses a SwiftData Model that's only stored in Memory
        let schema = Schema([
            Breed.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            self.testModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        // Initialize the store passing the testModelContainer and setups the first response
        self.sut = TestStore(
            initialState: Breeds.State(),
            reducer: {
                Breeds()
            })

        sut.dependencies.dataPersistenceService = DataPersistanceService.live(
            modelContext: self.testModelContainer.mainContext)

        sut.dependencies.catApiClient = CatApiClient(breeds: { [self] page, limit in
            firstResponse
        })

    }

    @Test func testLoads() async throws {

        await self.sut.send(.fetchLocalBreeds)

        await self.sut.receive(\.fetchMoreBreeds) {
            $0.breedsRequestInFlight = true
        }

        await self.sut.receive(\.breedsResponse.success) {
            $0.page = 1
            $0.breedsRequestInFlight = false
            $0.breeds = firstResponse
        }

        // Return an empty response to trigger end of pages
        self.sut.dependencies.catApiClient.breeds = { _, _ in [] }

        await self.sut.send(.fetchMoreBreeds) {
            $0.breedsRequestInFlight = true
        }

        await self.sut.receive(\.breedsResponse.success) {
            $0.breedsRequestInFlight = false
            $0.hasMoreBreedsToLoad = false
        }

    }

    @Test func testFavoriting() async throws {

        await self.sut.send(.fetchLocalBreeds)

        await self.sut.receive(\.fetchMoreBreeds) {
            $0.breedsRequestInFlight = true
        }

        await self.sut.receive(\.breedsResponse.success) {
            $0.page = 1
            $0.breedsRequestInFlight = false
            $0.breeds = firstResponse
        }

        await self.sut.send(.toggleFavorite(self.sut.state.breeds.first!))

        #expect(self.sut.state.favoriteBreeds.count == 1)
    }

    @Test func testLoadMoreData() async throws {

        await self.sut.send(.fetchLocalBreeds)

        await self.sut.receive(\.fetchMoreBreeds) {
            $0.breedsRequestInFlight = true
        }

        await self.sut.receive(\.breedsResponse.success) {
            $0.page = 1
            $0.breedsRequestInFlight = false
            $0.breeds = firstResponse
        }

        self.sut.dependencies.catApiClient.breeds = { _, _ in secondResponse }

        await self.sut.send(.displayedBreedCell(self.sut.state.breeds.last!))

        await self.sut.receive(\.fetchMoreBreeds) {
            $0.breedsRequestInFlight = true
        }

        await self.sut.receive(\.breedsResponse.success) {
            $0.page = 2
            $0.breedsRequestInFlight = false
            $0.breeds = firstResponse + secondResponse
        }
    }

    @Test func testFiltering() async throws {

        self.sut.dependencies.catApiClient.breeds = { _, _ in filterResponse }

        await self.sut.send(.fetchLocalBreeds)

        await self.sut.receive(\.fetchMoreBreeds) {
            $0.breedsRequestInFlight = true
        }

        await self.sut.receive(\.breedsResponse.success) {
            $0.page = 1
            $0.breedsRequestInFlight = false
            $0.breeds = filterResponse
        }

        await self.sut.send(.filterTextChange("Sia")) {
            $0.breedFilterText = "Sia"
        }

        #expect(self.sut.state.filteredBreeds.count == 1)
    }

    @Test func testOffline() async throws {

        await self.sut.send(.fetchLocalBreeds)

        await self.sut.receive(\.fetchMoreBreeds) {
            $0.breedsRequestInFlight = true
        }

        await self.sut.receive(\.breedsResponse.success) {
            $0.page = 1
            $0.breedsRequestInFlight = false
            $0.breeds = firstResponse
        }

        let savedBreeds = try self.sut.dependencies.dataPersistenceService.loadBreeds()

        #expect(savedBreeds.count == firstResponse.count)

    }

    @Test func testError() async throws {

        struct GenericError: Error {}

        self.sut.dependencies.catApiClient.breeds = { _, _ in throw GenericError() }

        await self.sut.send(.fetchLocalBreeds)

        await self.sut.receive(\.fetchMoreBreeds) {
            $0.breedsRequestInFlight = true
        }

        await self.sut.receive(\.breedsResponse.failure) {
            $0.hasError = true
            $0.breedsRequestInFlight = false
        }
    }
}
