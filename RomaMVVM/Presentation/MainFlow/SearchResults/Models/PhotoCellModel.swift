//
//  PhotoCellModel.swift
//  RomaMVVM
//
//  Created by User on 21.04.2023.
//

import Foundation

struct PhotoCellModel: Hashable {
    let uuid = UUID()
    let id: String?
    let image: URL?
    let street: String
    let house: Int
    let ort: String
    let livingArea: Int?
    let square: Int
    let numberOfRooms: String
    let price: Int
    let isFavourite: Bool
    
    init(id: String? = nil, image: URL, street: String, house: Int, ort: String, livingArea: Int, square: Int, numberOfRooms: String, price: Int, isFavourite: Bool = false) {
        self.id = id
        self.image = image
        self.street = street
        self.house = house
        self.ort = ort
        self.livingArea = livingArea
        self.square = square
        self.numberOfRooms = numberOfRooms
        self.price = price
        self.isFavourite = isFavourite
    }
    
    init(data: HouseDomainModel, isFavourite: Bool = false) {
        self.id = data.id
        self.image = data.images?.first
        self.street = data.street
        self.house = data.house
        self.ort = data.ort
        self.livingArea = data.livingArea
        self.square = data.square
        self.numberOfRooms = "\(data.roomsNumber)"
        self.price = data.price
        self.isFavourite = isFavourite
    }
    
    static func == (lhs: PhotoCellModel, rhs: PhotoCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

