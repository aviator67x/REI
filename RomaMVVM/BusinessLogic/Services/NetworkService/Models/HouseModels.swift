//
//  HouseModels.swift
//  RomaMVVM
//
//  Created by User on 06.04.2023.
//

import Foundation

struct HouseRequestModel: Encodable {
    let objectId: String
    let constructionYear: Int
    let garage: String
    let images: [URL]?
    let ort: String
    let livingArea: Int
    let square: Int
    let street: String
    let propertyType: String
    let roomsNumber: Int
    let price: Int
    
    init(objectId: String, constructionYear: Int, garage: String, images: [URL]? = nil, ort: String, livingArea: Int, square: Int, street: String, propertyType: String, roomsNumber: Int, price: Int) {
        self.objectId = objectId
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
}

struct HouseResponseModel: Decodable {
    let objectId: String
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
    let location: Point?
}

struct SaveHouseImageResponseModel: Decodable {
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "fileURL"
    }
}

