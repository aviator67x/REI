//
//  AdCreatingRequestModel.swift
//  RomaMVVM
//
//  Created by User on 18.05.2023.
//

import Foundation

struct AdCreatingRequestModel: Hashable {
    static var empty: Self {
    return . init()
    }
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
}
