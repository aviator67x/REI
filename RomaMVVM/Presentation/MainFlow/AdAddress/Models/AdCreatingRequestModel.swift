//
//  AdCreatingRequestModel.swift
//  RomaMVVM
//
//  Created by User on 18.05.2023.
//

import Foundation

struct AdCreatingRequestModel: Encodable, Hashable {
    static var empty: Self {
        return .init()
    }

    var ownerId: String?
    var location: Point?
    var ort: String?
    var street: String?
    var house: Int?
    var distance: Int?
    var propertyType: String?
    var price: Int?
    var roomsNumber: Int?
    var square: Int?
    var livingArea: Int?
    var constructionYear: Int?
    var garage: String?
    var images: [URL]?
}

struct Point: Codable, Hashable {
    var type: String
    var coordinates: [Double]
}
