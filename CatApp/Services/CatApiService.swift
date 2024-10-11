//
//  CatApiService.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import ComposableArchitecture
import Foundation

enum CatApiEndpoints {

    case breeds(page: Int, limit: Int)

    // Stored here for simplicity sake, in a real world app this should be server sided
    static var apiKey: String { "live_y4WPtEr06QAHnZGwDm3RC9wtxU2nGO54pBnsNUzlfxE5i7jW9M64sfrUl1Upq5Zl" }

    private var baseURL: String { "https://api.thecatapi.com/v1" }

    // Helper for building the URL
    var url: URL {
        var components = URLComponents(string: baseURL)!
        components.path += path
        components.queryItems = queryItems
        return components.url!
    }

    // API Endpoints
    var path: String {
        switch self {
        case .breeds:
            "/breeds"
        }
    }

    // Configurable Query items
    private var queryItems: [URLQueryItem] {
        switch self {
        case .breeds(page: let page, limit: let limit):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        }
    }

}

// MARK: Dependency
// Setup the API Client as a TCA Dependency
@DependencyClient
struct CatApiClient {
    var breeds: (_ page: Int, _ limit: Int) async throws -> [Breed]
}

private enum CatApiClientKey: DependencyKey {

    static let testValue = CatApiClient(
        breeds: { _, _ in
            return [Breed.mock(), Breed.mock(), Breed.mock()]
        }
    )

    static let previewValue: CatApiClient = CatApiClient(
        breeds: { _, _ in
            return [Breed.mock(), Breed.mock(), Breed.mock()]
        }
    )

    static let liveValue = CatApiClient(
        breeds: { page, limit in

            let url = CatApiEndpoints.breeds(page: page, limit: limit).url
            var request = URLRequest(url: url)
            request.addValue(CatApiEndpoints.apiKey, forHTTPHeaderField: "x-api-key")
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            return try decoder.decode([Breed].self, from: data)
        }
    )

}

extension DependencyValues {
    var catApiClient: CatApiClient {
        get { self[CatApiClientKey.self] }
        set { self[CatApiClientKey.self] = newValue }
    }
}
