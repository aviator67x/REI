//
//  DetailedModels.swift
//  RomaMVVM
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
    case plain(String)
}

enum SearchFiltersDetailedScreenState {
    case year
    case garage
}
