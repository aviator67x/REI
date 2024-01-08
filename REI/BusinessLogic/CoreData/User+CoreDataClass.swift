//
//  User+CoreDataClass.swift
//  REI
//
//  Created by User on 26.12.2023.
//
//

import CoreData
import Foundation

public class User: NSManagedObject {
    convenience init(
        userDomainModel: UserDomainModel,
        insertInto context: NSManagedObjectContext
    ) {
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context) else {
            fatalError("Can't create User entity")
        }
        self.init(entity: userEntity, insertInto: context)
        self.id = userDomainModel.id
        self.name = userDomainModel.name
        self.firstName = userDomainModel.firstName
        self.lastName = userDomainModel.lastName
        self.nickName = userDomainModel.nickName
        self.email = userDomainModel.email
        self.imageURL = String(describing: userDomainModel.imageURL)
//        guard let house = userDomainModel.favouriteHouses?.first else {
//            return
//        }
        guard let houses = userDomainModel.favouriteHouses else {
            return
        }
       let entityHouses = houses.compactMap {  House(
            houseDomainModel: $0,
            isFavourite: true,
            insertInto: context
        ) }
//        let set: Set<House> = [House(
//            houseDomainModel: house,
//            isFavourite: true,
//            insertInto: context
//        )]
        let set: Set<House> = Set(entityHouses)
        self.favouriteHouses = set // NSSet(array: userDomainModel.favouriteHouses ?? [])
    }
}
