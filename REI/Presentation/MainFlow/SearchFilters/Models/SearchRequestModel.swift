//
//  SearchRequestModel.swift
//  RomaMVVM
//
//  Created by User on 01.05.2023.
//

import Foundation

struct SearchRequestModel: Hashable {
    static var empty: Self {
    return . init()
    }
    
    var distanceOnSphere: String?
    var propertyType: PropertyType?
    var minPrice: Int?
    var maxPrice: Int?
    var roomsNumber: NumberOfRooms?
    var minSquare: Int?
    var maxSquare: Int?
    var constructionYear: PeriodOfBuilding?
    var garage: Garage?
    var ortPolygon: String?
}

enum Garage: String, CaseIterable {
    case garage = "Garage"
    case freeParking = "Free parking"
    case municipalParking = "Municipal parking"
    case hourlyPayableParking = "Hourly parking"
    case noParking = "No parking"
}

enum PeriodOfBuilding: Int
, CaseIterable {
    case since1850 = 1850
    case since1900 = 1900
    case since1950 = 1950
    case since2000 = 2000
    case since2010 = 2010
    case since2020 = 2020
}

enum Distance: Int, CaseIterable, Equatable {
    case one = 1
    case two = 2
    case five = 5
    case ten = 10
    case fifteen = 15
    case thirty = 30
    case fifty = 50
    case oneHundred = 100
}

enum PropertyType: String, CaseIterable, Equatable {
    case apartment
    case house
    case land
}

enum NumberOfRooms: Int, CaseIterable, Equatable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
}
