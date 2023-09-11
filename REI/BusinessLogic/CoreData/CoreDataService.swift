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
    func saveContext()
    func deleteObjects()
    func saveObjects(houseModels: [HouseDomainModel], isFavourite: Bool)
    func getObjects(by filter: String?, filterValue: Bool?) -> [HouseDomainModel]?
    func getObjects() -> [HouseDomainModel]?
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

    func saveContext() {
        guard backgroundContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

    func saveObjects(houseModels: [HouseDomainModel], isFavourite: Bool = false) {
        if !isFavourite {
            guard let notFavouriteObjects = getObjects(by: "isFavourite", filterValue: false) else {
                return
            }
            deleteObjects()
            notFavouriteObjects.map { House(
                houseDomainModel: $0,
                isFavourite: false,
                insertInto: backgroundContext
            ) }
        } else {
            deleteObjects()
            let coreDataHouseModels = houseModels.map { House(
                houseDomainModel:
                $0,
                isFavourite: isFavourite,
                insertInto: backgroundContext
            ) }
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

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [House] {
                managedContext.delete(data)

                do {
                    try managedContext.save()
                } catch {
                    debugPrint("Failed to save context with error \(error)")
                }
            }
        } catch {
            debugPrint("Failed to delete data with error \(error)")
        }
    }
}
