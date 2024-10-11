//
//  PersistanceClient.swift
//  CatApp
//
//  Created by Lucas Cardinali on 10/10/24.
//

import ComposableArchitecture
import SwiftData

@DependencyClient
struct DataPersistanceService {
    var loadBreeds: () throws -> [Breed]
    var updateBreeds: () throws -> Void
    var addBreed: (Breed) throws -> Void
}

extension DataPersistanceService: DependencyKey {

    static var liveValue: DataPersistanceService {
        fatalError("DataPersistenceService has not been provided. Please set it when initializing the store.")
    }
}

extension DependencyValues {
    var dataPersistenceService: DataPersistanceService {
        get { self[DataPersistanceService.self] }
        set { self[DataPersistanceService.self] = newValue }
    }
}

extension DataPersistanceService {
    static func live(modelContext: ModelContext) -> DataPersistanceService {
        return DataPersistanceService(
            loadBreeds: {
                let request = FetchDescriptor<Breed>()
                return try modelContext.fetch(request)
            },
            updateBreeds: {
                try modelContext.save()
            },
            addBreed: { breed in
                modelContext.insert(breed)
                try modelContext.save()
            }

        )
    }
}
