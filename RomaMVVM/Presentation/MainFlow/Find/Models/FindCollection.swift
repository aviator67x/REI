//
//  FindCollection.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Foundation

struct FindCollection {
    var section: FindSection
    var items: [FindItem]
}

enum FindSection: Hashable {
    case photo
    case list
    case main
    case map
}

enum FindItem: Hashable {
    case photo(PhotoCellModel)
    case main(MainCellModel)
    case list(ListCellModel)
    case map
}
