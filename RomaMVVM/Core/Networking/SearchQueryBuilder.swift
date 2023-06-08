//
//  SearchQueryBuilder.swift
//  RomaMVVM
//
//  Created by User on 10.03.2023.
//

import Foundation

enum SearchType: Equatable {
    case equalToInt(parameter: Int)
    case equalToString(parameter: String)
    case more(than: Int)
    case less(than: Int)
}

enum HouseColumn: CaseIterable {
    case ownerId
    case distance
    case price
    case propertyType
    case square
    case roomsNumber
    case constructionYear
    case garage
}

struct SearchParam: Equatable {
    let key: HouseColumn
    let value: SearchType
}

enum Search {
    case searchProperty([SearchParam])

    var query: [String: String]? {
        switch self {
        case let .searchProperty(searchParams):
            var searchItems: [String] = []
            for param in searchParams {
                switch param.value {
                case let .equalToInt(intValue):
                    searchItems.append("\(param.key) = \(intValue)")
                case let .equalToString(stringValue):
                    searchItems.append("\(param.key) = '\(stringValue)'")
                case let .more(value):
                    searchItems.append("\(param.key) >= \(value)")
                case let .less(value):
                    searchItems.append("\(param.key) <= \(value)")
                }
            }
            let result = searchItems.joined(separator: " and ")
            return ["where": result]
        }
    }
}
