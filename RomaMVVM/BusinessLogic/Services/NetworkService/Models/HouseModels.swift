//
//  HouseModels.swift
//  RomaMVVM
//
//  Created by User on 06.04.2023.
//

import Foundation

struct HouseResponceModel: Decodable {
//    let id: String
    let distance: Int
    let constructionYear: Int
    let garage: String
    let images: [URL]
    let ort: String
    let livingArea: Int
    let square: Int
    let street: String
    let propertyType: String
    let rooomsNumber: Int
    let price: Int

    enum CodinKeys: String, CodingKey {
        case distance, constructionYear, garage, images, ort, square, street, propertyType, rooomsNumber, livingArea, price
//        case id = "objectId"
    }
}
