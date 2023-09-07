//
//  House+CoreDataClass.swift
//  REI
//
//  Created by User on 07.09.2023.
//
//

import CoreData
import Foundation

@objc(House)
public class House: NSManagedObject {
    convenience init(
        houseDomainModel: HouseDomainModel,
        isFavourite: Bool,
        insertInto context: NSManagedObjectContext
    ) {
        guard let houseEntity = NSEntityDescription.entity(forEntityName: "House", in: context) else {
            fatalError("Can't create House entity")
        }
        self.init(entity: houseEntity, insertInto: context)
        self.constructionYear = Int64(houseDomainModel.constructionYear)
        self.garage = houseDomainModel.garage
        self.house = Int64(houseDomainModel.house)
        self.id = houseDomainModel.id
        self.isFavourite = isFavourite
        self.livingArea = Int64(houseDomainModel.livingArea)
        self.ort = houseDomainModel.ort
        guard let lat = houseDomainModel.location?.coordinates[0],
              let long = houseDomainModel.location?.coordinates[1] else {
            fatalError("No coordinates")
        }
        self.pointLatitude = lat
        self.pointLongitude = long
        self.price = Int64(houseDomainModel.price)
        self.propertyType = houseDomainModel.propertyType
        self.roomsNumber = Int64(houseDomainModel.roomsNumber)
        self.square = Int64(houseDomainModel.square)
        self.street = houseDomainModel.street
        guard let urls = houseDomainModel.images else {
            return
        }
        let urlStrings = urls.map { String(describing: $0) }
        self.urls = urlStrings
    }
}
