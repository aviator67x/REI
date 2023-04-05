//
//  FindCollection.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Foundation

struct FindCollection {
    var sections: FindSection
    var items: [FindItem]
}

enum FindSection: Hashable {
    case photlo
}

enum FindItem: Hashable {
    case photo(PhotoCellModel)
}

struct PhotoCellModel: Hashable {
    let uuid = UUID()
    let image: URL?
    let street: String
    let ort: String
    let numberOfRooms: String
    let square: Float
    let price: Float    
    
    static func == (lhs: PhotoCellModel, rhs: PhotoCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
