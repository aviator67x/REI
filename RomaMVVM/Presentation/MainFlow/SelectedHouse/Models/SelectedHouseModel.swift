//
//  SelectedHouseModel.swift
//  RomaMVVM
//
//  Created by User on 31.05.2023.
//

import Foundation

final class  SelectedHouseModel {
    let uuid = UUID()
    let id: String
    let image: URL?
    let street: String
    let house: Int
    let ort: String
    let livingArea: Int
    let square: Int
    let numberOfRooms: String
    let price: Int
    let isFavourite: Bool
    
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
}