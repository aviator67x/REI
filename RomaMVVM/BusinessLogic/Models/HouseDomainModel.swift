//
//  HouseDomainModel.swift
//  RomaMVVM
//
//  Created by User on 14.04.2023.
//

import Foundation

final class HouseDomainModel: Codable {
        let id: String
        let distance: Int
        let constructionYear: Int
        let garage: String
        let images: [URL]
        let ort: String
        let livingArea: Int
        let square: Int
        let street: String
        let propertyType: String
        let roomsNumber: Int
        let price: Int
    
    init(id: String, distance: Int, constructionYear: Int, garage: String, images: [URL], ort: String, livingArea: Int, square: Int, street: String, propertyType: String, roomsNumber: Int, price: Int) {
        self.id = id
        self.distance = distance
        self.constructionYear = constructionYear
        self.garage = garage
        self.images = images
        self.ort = ort
        self.livingArea = livingArea
        self.square = square
        self.street = street
        self.propertyType = propertyType
        self.roomsNumber = roomsNumber
        self.price = price
    }
    
    init(model: HouseResponseModel) {
        self.id = "HouseDomainModel"
        self.distance = model.distance
        self.constructionYear = model.constructionYear
        self.garage = model.garage
        self.images = model.images
        self.ort = model.ort
        self.livingArea = model.livingArea
        self.square = model.square
        self.street = model.street
        self.propertyType = model.propertyType
        self.roomsNumber = model.roomsNumber
        self.price = model.price
    }
}
