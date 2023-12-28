//
//  User+CoreDataClass.swift
//  REI
//
//  Created by User on 26.12.2023.
//
//

import Foundation
import CoreData


public class User: NSManagedObject {
    convenience init(
        userDomainModel: UserDomainModel,
        insertInto context: NSManagedObjectContext) {
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
            let set: NSSet = [userDomainModel.favouriteHouses?.first, userDomainModel.favouriteHouses?.last]
//            self.favouriteHouses = set//.init(array: userDomainModel.favouriteHouses ?? [])
    }
}
