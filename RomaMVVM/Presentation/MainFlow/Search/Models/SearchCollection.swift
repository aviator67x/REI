//
//  Models.swift
//  RomaMVVM
//
//  Created by User on 31.03.2023.
//

import Foundation
import Combine

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
    let uuid: UUID = UUID()
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
    let uuid: UUID = UUID()
    let minSquare: CurrentValueSubject<String?, Never>
    let maxSquare: CurrentValueSubject<String?, Never>

    static func == (lhs: SquareCellModel, rhs: SquareCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
