//
//  File.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import Foundation
import SwiftData

@Model
final class Breed: Identifiable, Decodable, Equatable {

    init(
        id: String,
        name: String,
        origin: String? = nil,
        temperament: String? = nil,
        description: String? = nil,
        lifeSpan: String? = nil,
        image: String? = nil
    ) {
        self.id = id
        self.name = name
        self.origin = origin
        self.temperament = temperament
        self.desc = description
        self.lifeSpan = lifeSpan
        self.image = image
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.origin = try container.decodeIfPresent(String.self, forKey: .origin)
        self.temperament = try container.decodeIfPresent(String.self, forKey: .temperament)
        self.desc = try container.decodeIfPresent(String.self, forKey: .desc)
        self.lifeSpan = try container.decodeIfPresent(String.self, forKey: .lifeSpan)

        if let imageContainer = try? container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image) {
            self.image = try imageContainer.decode(String.self, forKey: .url)
        } else {
            self.image = nil
        }
    }

    static func == (lhs: Breed, rhs: Breed) -> Bool {
        lhs.id == rhs.id
    }

    enum ImageCodingKeys: String, CodingKey {
        case url
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case origin
        case temperament
        case desc = "description"
        case lifeSpan
        case image
    }

    @Attribute(.unique) var id: String
    var name: String
    var origin: String?
    var temperament: String?
    var desc: String?
    var lifeSpan: String?
    var image: String?

    var favorite: Bool = false
}

extension Breed {

    static func mock() -> Breed {

        Breed(
            id: UUID().uuidString, name: "Abyssinian", origin: "Egypt",
            temperament: "Active, Energetic, Independent, Intelligent, Gentle",
            description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate",
            lifeSpan: "14 - 15",
            image: "https://live.staticflickr.com/1305/4680268546_09f37c6391_c.jpg")
    }
}
