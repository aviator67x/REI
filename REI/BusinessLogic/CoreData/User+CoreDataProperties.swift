//
//  User+CoreDataProperties.swift
//  REI
//
//  Created by User on 26.12.2023.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var nickName: String
    @NSManaged public var email: String
    @NSManaged public var imageURL: String
    @NSManaged public var favouriteHouses: Set<House>

}

// MARK: Generated accessors for favouriteHouses
extension User {

    @objc(addFavouriteHousesObject:)
    @NSManaged public func addToFavouriteHouses(_ value: House)

    @objc(removeFavouriteHousesObject:)
    @NSManaged public func removeFromFavouriteHouses(_ value: House)

    @objc(addFavouriteHouses:)
    @NSManaged public func addToFavouriteHouses(_ values: NSSet)

    @objc(removeFavouriteHouses:)
    @NSManaged public func removeFromFavouriteHouses(_ values: NSSet)

}

extension User : Identifiable {

}
