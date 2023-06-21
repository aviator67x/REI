//
//  AdMultiDetailsModels.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import Foundation

struct AdMultiDetailsCollection {
    var section: AdMultiDetailsSection
    var items: [AdMultiDetailsItem]
}

enum AdMultiDetailsSection: Hashable {
    case plain
}

enum AdMultiDetailsItem: Hashable {
    case garage(Garage)
    case type(PropertyType)
    case number(NumberOfRooms)
    case yearPicker(Int)
    case livingAreaSlider(Int)
    case squareSlider(Int)
    case priceSlider(Int)

    func hash(into hasher: inout Hasher) {
        switch self {
        case let .garage(value):
            hasher.combine(value)
        case let .type(type):
            hasher.combine(type)
        case let .number(number):
            hasher.combine(number)
        case let .yearPicker(year):
            hasher.combine(year)
        case let .livingAreaSlider(area):
            hasher.combine(area)
        case let .squareSlider(square):
            hasher.combine(square)
        case let .priceSlider(price):
            hasher.combine(price)
        }
    }
}

enum AdMultiDetailsScreenState {
    case year
    case garage
    case type
    case number
    case livingArea
    case square
    case price
}
