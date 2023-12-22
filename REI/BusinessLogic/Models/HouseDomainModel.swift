//
//  HouseDomainModel.swift
//  REI
//
//  Created by User on 14.04.2023.
//

import Foundation

final class HouseDomainModel: Codable {
    let id: String
    let constructionYear: Int
    let garage: String
    var images: [URL]?
    let ort: String
    let livingArea: Int
    let square: Int
    let street: String
    let house: Int
    let propertyType: String
    let roomsNumber: Int
    let price: Int
    let location: Point?

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
        location: Point
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

    init(coreDataModel: House) {
        var images: [URL]?
        let urlStrings = coreDataModel.urls
        urlStrings?.forEach { string in
            if let url = URL(string: string) {
                images == nil ? images = [url] : images?.append(url)
            }
        }
        self.images = images
        self.id = coreDataModel.id
        self.constructionYear = Int(coreDataModel.constructionYear)
        self.garage = coreDataModel.garage
        self.ort = coreDataModel.ort
        self.livingArea = Int(coreDataModel.livingArea)
        self.square = Int(coreDataModel.square)
        self.street = coreDataModel.street
        self.house = Int(coreDataModel.house)
        self.propertyType = coreDataModel.propertyType
        self.roomsNumber = Int(coreDataModel.roomsNumber)
        self.price = Int(coreDataModel.price)
        let latitude = Double(coreDataModel.pointLatitude)
        let longitude = Double(coreDataModel.pointLongitude)
        self.location = Point(type: "Point", coordinates: [latitude, longitude])
    }
}
