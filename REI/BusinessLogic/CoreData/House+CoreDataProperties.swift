//
//  House+CoreDataProperties.swift
//  REI
//
//  Created by User on 07.09.2023.
//
//

import Foundation
import CoreData


extension House {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<House> {
        return NSFetchRequest<House>(entityName: "House")
    }

    @NSManaged public var constructionYear: Int64
    @NSManaged public var garage: String
    @NSManaged public var house: Int64
    @NSManaged public var id: String
    @NSManaged public var isFavourite: Bool
    @NSManaged public var livingArea: Int64
    @NSManaged public var ort: String
    @NSManaged public var pointLatitude: Double
    @NSManaged public var pointLongitude: Double
    @NSManaged public var price: Int64
    @NSManaged public var propertyType: String
    @NSManaged public var roomsNumber: Int64
    @NSManaged public var square: Int64
    @NSManaged public var street: String
    @NSManaged public var urls: [String]?

}

extension House : Identifiable {

}
