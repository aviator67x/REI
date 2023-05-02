//
//  Models.swift
//  RomaMVVM
//
//  Created by User on 31.03.2023.
//

import Combine
import Foundation

struct SearchFiltersCollection {
    let sections: SearchFiltersSection
    let items: [SearchFiltersItem]
}

enum SearchFiltersSection: Hashable, CaseIterable {
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

enum SearchFiltersItem: Hashable {
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




