//
//  FavouriteCollection.swift
//  REI
//
//  Created by User on 07.05.2023.
//

import Foundation

struct FavouriteCollection {
    var section: FavouriteSection
    var items: [FavouriteItem]
}

enum FavouriteSection: Hashable {
    case photo
  
}

enum FavouriteItem: Hashable {
    case photo(PhotoCellModel)
}
