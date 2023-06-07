//
//  HouseImagesCollection.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import Foundation

struct HouseImagesCollection {
    var section: HouseImagesSection
    var items: [HouseImagesItem]
}

enum HouseImagesSection: Hashable {
    case photo
}

enum HouseImagesItem: Hashable {
    case photo(URL)
}
