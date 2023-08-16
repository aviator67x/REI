//
//  SwiftUIViewModel.swift
//  REI
//
//  Created by User on 14.08.2023.
//

import Combine
import SwiftUI
import CoreData

final class SwiftUIViewModel: BaseViewModel, ObservableObject {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SwiftUITransition, Never>()
    
    @Published var title: String = "Initial title"
    
    let coreDataStack = CoreDataStack(modelName: "House")
    
    override init() {

        super.init()
    }
    
    func saveHousesToCD() {
    debugPrint("I'm savieng to CD")
        coreDataStack.saveObjects()
    }
    
    func retrieveHousesFromCD() {
        debugPrint("I'm retrieving from CD")
        coreDataStack.getObjects(entiityName: "House")
    }
}
