//
//  DetailedModels.swift
//  RomaMVVM
//
//  Created by User on 04.04.2023.
//

import Foundation

struct DetailedCollection {
    var section: DetailedSection
    var items: [DetailedItem]
}

enum DetailedSection: Hashable {
    case plain
}

enum DetailedItem: Hashable {
    case plain(String)
}

enum ScreenState {
    case year
    case garage
}
