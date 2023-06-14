//
//  HouseDomainModel.swift
//  RomaMVVM
//
//  Created by User on 14.04.2023.
//

import Foundation

final class HouseDomainModel: Codable {
    let id: String
    let constructionYear: Int
    let garage: String
    let images: [URL]?
    let ort: String
    let livingArea: Int
    let square: Int
    let street: String
    let house: Int
    let propertyType: String
    let roomsNumber: Int
    let price: Int
    let location: Location

    init(
        id: String,
        constructionYear: Int,
        garage: String,
        images: [URL],
        ort: String,
        livingArea: Int,
        square: Int,
        street: String,
        house: Int,
        propertyType: String,
        roomsNumber: Int,
        price: Int,
        location: Location
    ) {
        self.id = id
        self.constructionYear = constructionYear
        self.garage = garage
        self.images = images
        self.ort = ort
        self.livingArea = livingArea
        self.square = square
        self.street = street
        self.house = house
        self.propertyType = propertyType
        self.roomsNumber = roomsNumber
        self.price = price
        self.location = location
    }

    init(model: HouseResponseModel) {
        self.id = model.objectId
        self.constructionYear = model.constructionYear
        self.garage = model.garage
        self.images = model.images
        self.ort = model.ort
        self.livingArea = model.livingArea
        self.square = model.square
        self.street = model.street
        self.house = model.house
        self.propertyType = model.propertyType
        self.roomsNumber = model.roomsNumber
        self.price = model.price
        self.location = model.location
    }
}
