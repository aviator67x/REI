//
//  DetailedModels.swift
//  REI
//
//  Created by User on 04.04.2023.
//

import Foundation

struct SearchFiltersDetailedCollection {
    var section: SearchFiltersDetailedSection
    var items: [SearchFiltersDetailedItem]
}

enum SearchFiltersDetailedSection: Hashable {
    case plain
}

enum SearchFiltersDetailedItem: Hashable {
    case plainYear(PeriodOfBuilding)
    case plainGarage(Garage)
    
    func hash(into hasher: inout Hasher) {
            switch self {
            case .plainYear(let value):
                hasher.combine(value)
            case .plainGarage(let value):
                hasher.combine(value)
            }
        }
}

enum SearchFiltersDetailedScreenState {
    case year
    case garage
}
