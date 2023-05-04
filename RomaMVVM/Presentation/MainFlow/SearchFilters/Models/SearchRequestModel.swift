//
//  SearchRequestModel.swift
//  RomaMVVM
//
//  Created by User on 01.05.2023.
//

import Foundation

struct SearchRequestModel: Hashable {
    var distance: Distance?
    var propertyType: PropertyType?
    var minPrice: String?
    var maxPrice: String?
    var roomsNumber: String?
    var minSquare: String?
    var maxSquare: String?
    var constructionYear: String?
    var garage: String?
    
    enum Distance: Int, CaseIterable {
        case one
        case two
        case five
        case ten
        case fifteen
        case thirty
        case fifty
        case oneHundred
    }
    
    enum PropertyType: String, CaseIterable {
        case apartment
        case house
        case land
    }
    
    enum NumberOfRooms: Int, CaseIterable {
        case one
        case two
        case three
        case four
        case five
    }
    
    enum PeriodOfBuilding: String, CaseIterable {
        case since1850
        case since1900
        case since1950
        case since2000
        case since2010
        case since2020
    }
    
    enum Garage: String, CaseIterable {
        case garage
        case freeParking
        case municipalParking
        case hourlyPayableParking
        case noParking
    }
}
