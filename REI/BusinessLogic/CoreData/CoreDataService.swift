//
//  CoreDataService.swift
//  REI
//
//  Created by User on 15.08.2023.
//

import CoreData
import Foundation
import UIKit

protocol CoreDataStackProtocol {
    func deleteObjects()
    func saveObjects(houseModels: [HouseDomainModel], isFavourite: Bool?)
    func getObjects(by filter: String?, filterValue: Bool?) -> [HouseDomainModel]?
    func getObjects() -> [HouseDomainModel]?
    func saveUser(_ user: UserDomainModel)
    func getUser() -> UserDomainModel?
}

class CoreDataStack: CoreDataStackProtocol {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HouseManagedModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

    lazy var backgroundContext: NSManagedObjectContext = self.storeContainer.newBackgroundContext()

    func saveObjects(houseModels: [HouseDomainModel], isFavourite: Bool? = false) {
        deleteObjects()
        let count = getObjects()?.count
//        guard let savedUser = UserDefaults.standard.object(forKey: "User") as? Data,
//              let user = UserDefaults.standard.decode(type: UserDomainModel.self, data: savedUser),
//              let favouriteHouses = user.favouriteHouses
        guard let savedUser = getUser(),
              let favouriteHouses = savedUser.favouriteHouses
                
        else {
            return
        }

        var favouriteHousesIds: [String] = []
        favouriteHouses.forEach {
            favouriteHousesIds.append($0.id)
        }

        if let isFavourite = isFavourite {
            let cdHouses = houseModels.map {
                House(
                    houseDomainModel:
                    $0,
                    isFavourite: isFavourite,
                    insertInto: backgroundContext
                )
            }
        } else {
            houseModels.map {
                let isFavourite: Bool = favouriteHousesIds.contains($0.id) ? true : false
                House(
                    houseDomainModel:
                    $0,
                    isFavourite: isFavourite,
                    insertInto: backgroundContext
                )
            }
        }
        do {
            try backgroundContext.save()
            debugPrint("I think trial houses have been saved to Core Data")
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getObjects(by filter: String? = nil, filterValue: Bool? = nil) -> [HouseDomainModel]? {
        var domainModels: [HouseDomainModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")

        if let filter = filter,
           let filterValue = filterValue
        {
            let predicate = NSPredicate(format: "\(filter) == %@", NSNumber(booleanLiteral: filterValue))
            fetchRequest.predicate = predicate
        }
        do {
            let result = try managedContext.fetch(fetchRequest) as? [House]
            guard let result = result else {
                return nil
            }
            domainModels = result.map { HouseDomainModel(coreDataModel: $0) }
        } catch {
            debugPrint("Failed")
        }
        return domainModels
    }

    func getObjects() -> [HouseDomainModel]? {
        var domainModels: [HouseDomainModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")
        do {
            let result = try managedContext.fetch(fetchRequest) as? [House]
            guard let result = result else {
                return nil
            }
            domainModels = result.map { HouseDomainModel(coreDataModel: $0) }
        } catch {
            debugPrint("Failed")
        }
        return domainModels
    }

    func deleteObjects() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.persistentStoreCoordinator?.execute(deleteRequest, with: managedContext)
        } catch {
            debugPrint("Failed to delete data with error \(error)")
        }
    }

    func saveUser(_ user: UserDomainModel) {
        
        deleteUser()
        User(
            userDomainModel: user,
            insertInto: backgroundContext
        )

        do {
            try backgroundContext.save()
            debugPrint("I think trial houses have been saved to Core Data")
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getUser() -> UserDomainModel? {
        var user: UserDomainModel?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedContext.fetch(fetchRequest) as? [User]
            guard let result = result?.first else {
                return nil
            }
            user = UserDomainModel(coreDataModel: result)

        } catch {
            debugPrint("Failed")
        }
        return user
    }
    
    func deleteUser() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.persistentStoreCoordinator?.execute(deleteRequest, with: managedContext)
        } catch {
            debugPrint("Failed to delete data with error \(error)")
        }
    }
}
