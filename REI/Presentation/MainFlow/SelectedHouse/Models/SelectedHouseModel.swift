//
//  SelectedHouseModel.swift
//  RomaMVVM
//
//  Created by User on 31.05.2023.
//

import Foundation

struct  SelectedHouseModel {
    let uuid = UUID()
    let id: String
    let image: URL?
    let street: String
    let house: Int
    let location: Point?
    let ort: String
    let livingArea: Int
    let square: Int
    let numberOfRooms: String
    let price: Int
    var isFavourite: Bool
    
    init(data: HouseDomainModel, isFavourite: Bool = false) {
        self.id = data.id
        self.image = data.images?.first
        self.street = data.street
        self.house = data.house
        self.location = data.location
        self.ort = data.ort
        self.livingArea = data.livingArea
        self.square = data.square
        self.numberOfRooms = "\(data.roomsNumber)"
        self.price = data.price
        self.isFavourite = isFavourite
    }
}
