//
//  SwiftUIViewModel.swift
//  REI
//
//  Created by User on 14.08.2023.
//

import Combine
import CoreData
import Kingfisher
import SwiftUI

final class SwiftUIViewModel: BaseViewModel, ObservableObject {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SwiftUITransition, Never>()

    @Published var title = "Initial title"
    @Published var images: [URL] = []
    @Published var streetName = ""

    let coreDataStack = CoreDataStack(modelName: "House")

    @Published var data: [URL] = []

    override init() {
        super.init()
    }

    func saveHousesToCD() {
//        debugPrint("I'm savieng to CD")
//        coreDataStack.saveObjects()
    }

    func retrieveHousesFromCD() {
        debugPrint("I'm retrieving from CD")
        let houses = coreDataStack.getObjects()
        guard let images = houses?.first?.images,
              let street = houses?.first?.location?.coordinates[0]
        else {
            return
        }
        data = images
        streetName = "Latitude is: \(street)"
    }
}
