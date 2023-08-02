//
//  MyHouseCollection.swift
//  REI
//
//  Created by User on 08.06.2023.
//

import Foundation

struct MyHouseCollection {
    var section: MyHouseSection
    var items: [MyHouseItem]
}

enum MyHouseSection: Hashable {
    case photo
  
}

enum MyHouseItem: Hashable {
    case photo(PhotoCellModel)
}
