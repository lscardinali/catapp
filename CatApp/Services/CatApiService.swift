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

    private var baseURL: String { "https://api.thecatapi.com/v1" }

    var url: URL {
        var components = URLComponents(string: baseURL)!
        components.path += path
        components.queryItems = queryItems
        return components.url!
    }

    var path: String {
        switch self {
        case .breeds:
            "/breeds"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .breeds(page: let page, limit: let limit):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit)),
            ]
        }
    }

}

@DependencyClient
struct CatApiClient {
    var breeds: @Sendable (_ page: Int, _ limit: Int) async throws -> [Breed]
}

private enum CatApiClientKey: DependencyKey {

    static let liveValue = CatApiClient(
        breeds: { page, limit in
            let url = CatApiEndpoints.breeds(page: page, limit: limit).url
            var request = URLRequest(url: url)
            request.addValue("live_y4WPtEr06QAHnZGwDm3RC9wtxU2nGO54pBnsNUzlfxE5i7jW9M64sfrUl1Upq5Zl", forHTTPHeaderField: "x-api-key")
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode([Breed].self, from: data)
        }
    )

}

extension DependencyValues {
    var catApiClient: CatApiClient {
        get { self[CatApiClientKey.self] }
        set { self[CatApiClientKey.self] = newValue }
    }
}
