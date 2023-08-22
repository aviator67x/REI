//
//  CoreDataService.swift
//  REI
//
//  Created by User on 15.08.2023.
//

import CoreData
import Foundation
import UIKit

class CoreDataStack {
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

    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

    func saveObjects() {
        let houseModels: [HouseDomainModel] = [
            HouseDomainModel(
                id: "firstId",
                constructionYear: 1111,
                garage: "",
                images: [URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0411-min.jpg")!, URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0410-min.jpg")!],
                ort: "",
                livingArea: 0,
                square: 0,
                street: "",
                house: 0,
                propertyType: "",
                roomsNumber: 0,
                price: 0,
                location: Point(type: "point", coordinates: [1.1, 1.1])
            ),
            HouseDomainModel(
                id: "secondtId",
                constructionYear: 2222,
                garage: "",
                images: [URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0413-min.jpg")!, URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0408-min.jpg")!],
                ort: "",
                livingArea: 0,
                square: 0,
                street: "",
                house: 0,
                propertyType: "",
                roomsNumber: 0,
                price: 0,
                location: Point(type: "point", coordinates: [1.1, 1.1])
            ),
        ]
        
        self.deleteObjects()

        guard let houseEntity = NSEntityDescription.entity(forEntityName: modelName, in: managedContext) else {
            return
        }
        for index in 0 ... houseModels.count - 1 {
            let house = NSManagedObject(entity: houseEntity, insertInto: managedContext)
            house.setValue(houseModels[index].constructionYear, forKey: "constructionYear")
            house.setValue(houseModels[index].id, forKey: "id")
            
            guard let urls = houseModels[index].images else {
                return
            }
          let urlStrings = urls.map { String(describing: $0) }
            house.setValue(urlStrings, forKey: "urls")
        }

        do {
            try managedContext.save()
            debugPrint("I think trial houses have been saved to Core Data")
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getObjects(entiityName: String, completionHandler: ((HouseDomainModel) -> Void)?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entiityName)

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if let imageArray = data.value(forKey: "urls") as? [String],
                   let id = data.value(forKey: "id") as? String,
                   let constructionYear = data.value(forKey: "constructionYear") as? Int {
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
                        garage: "someGarage",
                        images: urlArray,
                        ort: "someTown",
                        livingArea: 20,
                        square: 30,
                        street: "someStreet",
                        house: 11,
                        propertyType: "someType",
                        roomsNumber: 5,
                        price: 100,
                        location: Point(type: "Point", coordinates: [1.1, 2.2]))
                    
                    completionHandler?(houseDomainModel)
                }
            }
        } catch {
            debugPrint("Failed")
        }
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
