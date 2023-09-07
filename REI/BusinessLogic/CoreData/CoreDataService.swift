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
    func getObjects(by filter: String?) -> [HouseDomainModel]?
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

    func saveObjects(houseModels: [HouseDomainModel], isFavourite: Bool) {
        deleteObjects()
        let coreDataHouseModels = houseModels.map { House(
            houseDomainModel:
            $0,
            isFavourite: true,
            insertInto: backgroundContext
        ) }
        do {
            try backgroundContext.save()
            debugPrint("I think trial houses have been saved to Core Data")
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getObjects(by filter: String? = nil) -> [HouseDomainModel]? {
        var domainModels: [HouseDomainModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")

        if let filter = filter {
            let predicate = NSPredicate(format: "isFavourite == %@", NSNumber(booleanLiteral: true))
            fetchRequest.predicate = predicate
        }
        do {
            let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            guard let result = result else {
                return nil
            }
            for data in result {
                let isFavourite = data.value(forKey: "isFavourite") as? Bool
                print(isFavourite)
                if let id = data.value(forKey: "id") as? String,
                   let constructionYear = data.value(forKey: "constructionYear") as? Int,
                   let imageArray = data.value(forKey: "urls") as? [String],
                   let garage = data.value(forKey: "garage") as? String,
                   let ort = data.value(forKey: "ort") as? String,
                   let livingArea = data.value(forKey: "livingArea") as? Int,
                   let square = data.value(forKey: "square") as? Int,
                   let street = data.value(forKey: "street") as? String,
                   let house = data.value(forKey: "house") as? Int,
                   let propertyType = data.value(forKey: "propertyType") as? String,
                   let roomsNumber = data.value(forKey: "roomsNumber") as? Int,
                   let price = data.value(forKey: "price") as? Int,
                   let latitude = data.value(forKey: "pointLatitude") as? Double,
                   let longitude = data.value(forKey: "pointLongitude") as? Double
                {
                    var urlArray = [URL]()
                    imageArray.forEach {
                        guard let url = URL(string: $0) else {
                            return
                        }
                        urlArray.append(url)
                    }

                    let houseDomainModel = HouseDomainModel(
                        id: id,
                        constructionYear: constructionYear,
                        garage: garage,
                        images: urlArray,
                        ort: ort,
                        livingArea: livingArea,
                        square: square,
                        street: street,
                        house: house,
                        propertyType: propertyType,
                        roomsNumber: roomsNumber,
                        price: price,
                        location: Point(type: "Point", coordinates: [latitude, longitude])
                    )

                    domainModels.append(houseDomainModel)
                }
            }
        } catch {
            debugPrint("Failed")
        }
        return domainModels
    }

    func deleteObjects() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
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
