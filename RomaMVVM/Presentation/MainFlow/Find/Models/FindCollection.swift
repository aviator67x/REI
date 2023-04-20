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
}

enum FindItem: Hashable {
    case photo(PhotoCellModel)
    case activity(LoadingFooter)
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
    
    init(image: URL, street: String, ort: String, livingArea: Int, square: Int, numberOfRooms: String, price: Int) {
        self.image = image
        self.street = street
        self.ort = ort
        self.livingArea = livingArea
        self.square = square
        self.numberOfRooms = numberOfRooms
        self.price = price
    }
    
    init(data: HouseDomainModel) {
        self.image = data.images.first
        self.street = data.street
        self.ort = data.ort
        self.livingArea = data.livingArea
        self.square = data.square
        self.numberOfRooms = "\(data.rooomsNumber)"
        self.price = data.price
    }
    
    static func == (lhs: PhotoCellModel, rhs: PhotoCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
