//
//  Models.swift
//  RomaMVVM
//
//  Created by User on 31.03.2023.
//

import Combine
import Foundation

struct SearchCollection {
    let sections: SearchSection
    let items: [SearchItem]
}

enum SearchSection: Hashable, CaseIterable {
    case segmentControl
    case distance
    case price
    case type
    case square
    case roomsNumber
    case year
    case garage
    case backgroundItem

    var headerTitle: String? {
        switch self {
        case .distance:
            return "Distance"
        case .price:
            return "Price category"
        case .type:
            return "Type of property"
        case .square:
            return"Square of the property in sqm"
        case .roomsNumber:
            return "Number of rooms"
        case .segmentControl, .year, .garage, .backgroundItem:
            return nil
        }
    }

    var headerImageName: String? {
        switch self {
        case .distance:
            return "plus"
        case .price:
            return "eurosign"
        case .type:
            return "homekit"
        case .square:
            return "light.panel"
        case .roomsNumber:
            return "door.right.hand.open"
        case .segmentControl, .year, .garage, .backgroundItem:
            return nil
        }
    }
    
    var isFooterNeeded: Bool {
        switch self {
        case .distance, .price, .type, .square, .roomsNumber, .year, .segmentControl, .garage:
            return true
        case .backgroundItem:
            return false
        }
    }
}

enum SearchItem: Hashable {
    case segmentControl
    case distance(String)
    case price(model: PriceCellModel)
    case type(String)
    case square(model: SquareCellModel)
    case roomsNumber(String)
    case year
    case garage
    case backgroundItem
}

final class SearchRequestModel {
    var distance: String?
    var propertyType: String?
    var minPrice: String?
    var maxPrice: String?
    var roomsNumber: String?
    var minSquare: String?
    var maxSquare: String?
    var constructionYear: String?
    var garage: String?
}

struct PriceCellModel: Hashable {
    let uuid = UUID()
    let minPrice: CurrentValueSubject<String?, Never>
    let maxPrice: CurrentValueSubject<String?, Never>

    static func == (lhs: PriceCellModel, rhs: PriceCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct SquareCellModel: Hashable {
    let uuid = UUID()
    let minSquare: CurrentValueSubject<String?, Never>
    let maxSquare: CurrentValueSubject<String?, Never>

    static func == (lhs: SquareCellModel, rhs: SquareCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
