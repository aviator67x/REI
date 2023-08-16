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

    func saveHouses() {
        let houseModels: [HouseDomainModel] = [
            HouseDomainModel(id: "firstId", constructionYear: 1111, garage: "", images: [], ort: "", livingArea: 0, square: 0, street: "", house: 0, propertyType: "", roomsNumber: 0, price: 0, location: Point(type: "point", coordinates: [1.1, 1.1])),
            HouseDomainModel(id: "secondtId", constructionYear: 2222, garage: "", images: [], ort: "", livingArea: 0, square: 0, street: "", house: 0, propertyType: "", roomsNumber: 0, price: 0, location: Point(type: "point", coordinates: [1.1, 1.1]))
        ]
        
        guard let houseEntity = NSEntityDescription.entity(forEntityName: modelName, in: managedContext) else {
            return
        }
        for index in 0...houseModels.count-1 {
            let house = NSManagedObject(entity: houseEntity, insertInto: managedContext)
            house.setValue(houseModels[index].constructionYear, forKey: "constructionYear")
            house.setValue(houseModels[index].id, forKey: "id")
        }
        
        do {
            try managedContext.save()
            debugPrint("I think trial houses have been saved to Core Data")
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
            
        }
    }
    
    func getHouses() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "id"))
                
            }
        } catch {
            debugPrint("Failed")
        }
    }
}
