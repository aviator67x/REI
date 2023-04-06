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
    let livingArea: Int
    let square: Int
    let numberOfRooms: String
    let price: Int
    
    static func == (lhs: PhotoCellModel, rhs: PhotoCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
