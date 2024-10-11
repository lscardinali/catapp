//
//  CatAppApp.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import SwiftData
import SwiftUI

@main
struct CatApp: App {

    var sharedModelContainer: ModelContainer

    init() {
        let args = ProcessInfo.processInfo.arguments

        let schema = Schema([
            Breed.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: args.contains("--uitesting"))

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppTabs(
                store: Store(
                    initialState: Breeds.State(),
                    reducer: {
                        Breeds()._printChanges()
                    },
                    withDependencies: { dependencies in
                        dependencies.dataPersistenceService = DataPersistanceService.live(
                            modelContext: sharedModelContainer.mainContext)
                    }))
        }
        .modelContainer(sharedModelContainer)
    }
}
