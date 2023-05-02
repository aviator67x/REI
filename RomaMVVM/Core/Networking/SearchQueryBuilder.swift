//
//  SearchQueryBuilder.swift
//  RomaMVVM
//
//  Created by User on 10.03.2023.
//

import Foundation

enum SearchType {
    case equalToInt(parameter: Int)
    case equalToString(parameter: String)
    case more(than: Int)
    case less(than: Int)
}

enum HouseColumn: CaseIterable {
    case distance
    case price
    case propertyType
    case square
    case roomsNumber
    case constructionYear
    case garage
   

    enum Distance: String {
        case one = "+ 1"
        case two = "+ 2"
        case five = "+ 5"
        case ten = "+ 10"
        case fifteen = "+ 15"
        case thirty = "+ 30"
        case fifty = "+ 50"
        case oneHundred = "+ 100"
    }
    
    enum PropertyType {
        case appartment
        case house
        case land
    }
}

enum PropertyColumn: String, CaseIterable {
    case layout
    case propertyType
    case realEstateCategory
    case residenceType
    case saleOrRent

    enum Layout: String, CaseIterable {
        case null = "0 + 1"
        case one = "1 + 1"
        case two = "2 + 1"
        case three = "3 + 1"
    }

    enum PropertyType: String, CaseIterable {
        case flat = "Flat"
        case villa = "Villa"
        case land = "Land"
        case hotDeals = "Hot Deals"
    }

    enum RealEstateCategoty: String, CaseIterable {
        case built = "Built"
        case underConstuction = "Under construction"
        case resale = "Resale"
    }

    enum ResidenceType: String, CaseIterable {
        case citizenship = "Citizenship"
        case residentCard = "ResidentCard"
    }

    enum SaleOrRent: String, CaseIterable {
        case sale = "Sale"
        case rent = "Rent"
    }
}

struct SearchParam {
//    let key: PropertyColumn
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
