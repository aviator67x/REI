//
//  FindCollection.swift
//  REI
//
//  Created by User on 05.04.2023.
//

import Foundation

struct SearchResultsCollection {
    var section: SearchResultsSection
    var items: [SearchResultsItem]
}

enum SearchResultsSection: Hashable {
    case photo
    case list
    case main
}

enum SearchResultsItem: Hashable {
    case photo(PhotoCellModel)
    case main(MainCellModel)
    case list(ListCellModel)
}
