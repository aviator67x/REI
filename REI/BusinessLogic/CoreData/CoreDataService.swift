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
    func saveObjects(houseModels: [HouseDomainModel])
    func getObjects() -> [HouseDomainModel]
}

class CoreDataStack: CoreDataStackProtocol {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
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

    func saveObjects(houseModels: [HouseDomainModel]) {
//        let houseModels: [HouseDomainModel] = [
//            HouseDomainModel(
//                id: "firstId",
//                constructionYear: 2023,
//                garage: "TiefGarage",
//                images: [
//                    URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0411-min.jpg")!,
//                    URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0410-min.jpg")!,
//                ],
//                ort: "Heimerdingen",
//                livingArea: 68,
//                square: 76,
//                street: "Feuerbacher",
//                house: 48,
//                propertyType: PropertyType.apartment.rawValue,
//                roomsNumber: 3,
//                price: 530_000,
//                location: Point(type: "point", coordinates: [1.1, 1.1])
//            ),
//            HouseDomainModel(
//                id: "secondtId",
//                constructionYear: 2222,
//                garage: "someGarage",
//                images: [
//                    URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0413-min.jpg")!,
//                    URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0408-min.jpg")!,
//                ],
//                ort: "SomeCity",
//                livingArea: 20,
//                square: 30,
//                street: "someStreet",
//                house: 10,
//                propertyType: PropertyType.house.rawValue,
//                roomsNumber: 5,
//                price: 200_000,
//                location: Point(type: "point", coordinates: [1.1, 1.1])
//            ),
//        ]

        deleteObjects()

        guard let houseEntity = NSEntityDescription.entity(forEntityName: modelName, in: backgroundContext) else {
            return
        }
        for index in 0 ... houseModels.count - 1 {
            let house = NSManagedObject(entity: houseEntity, insertInto: backgroundContext)
            house.setValue(houseModels[index].id, forKey: "id")
            house.setValue(houseModels[index].constructionYear, forKey: "constructionYear")
            house.setValue(houseModels[index].garage, forKey: "garage")
            guard let urls = houseModels[index].images else {
                return
            }
            let urlStrings = urls.map { String(describing: $0) }
            house.setValue(urlStrings, forKey: "urls")
            house.setValue(
                houseModels[index].ort,
                forKey: "ort"
            )
            house.setValue(houseModels[index].livingArea, forKey: "livingArea")
            house.setValue(houseModels[index].square, forKey: "square")
            house.setValue(houseModels[index].street, forKey: "street")
            house.setValue(houseModels[index].house, forKey: "house")
            house.setValue(houseModels[index].propertyType, forKey: "propertyType")
            house.setValue(houseModels[index].roomsNumber, forKey: "roomsNumber")
            house.setValue(houseModels[index].location?.coordinates[0], forKey: "pointLatitude")
            house.setValue(houseModels[index].location?.coordinates[1], forKey: "pointLongitude")
        }

        do {
            try backgroundContext.save()
            debugPrint("I think trial houses have been saved to Core Data")
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getObjects() -> [HouseDomainModel] {
        var domainModels: [HouseDomainModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
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
