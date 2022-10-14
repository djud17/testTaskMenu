//
//  File.swift
//  testTaskMenu
//
//  Created by Давид Тоноян  on 13.10.2022.
//

import Foundation

struct ProductCategory: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductElement
struct Product: Codable {
    let id: String
    let categoryID, name: CategoryID
    let image: String
    let productDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "categoryId"
        case name, image
        case productDescription = "description"
    }
}

enum CategoryID: Codable {
    case integerArray([Int])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode([Int].self) {
            self = .integerArray(intValue)
            return
        }
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }
        throw DecodingError.typeMismatch(CategoryID.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Wrong type for CategoryID"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integerArray(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        }
    }
}
