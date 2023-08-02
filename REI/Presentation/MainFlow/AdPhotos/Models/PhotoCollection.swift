//
//  PhotoCollection.swift
//  REI
//
//  Created by User on 29.05.2023.
//

import Foundation

struct PhotoCollection {
    var section: HousePhotoSection
    var items: [HousePhotoItem]
}

enum HousePhotoSection: Hashable {
    case photo
}

enum HousePhotoItem: Hashable {
    case photo(Data)
}
