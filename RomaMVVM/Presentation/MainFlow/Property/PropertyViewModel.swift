//
//  PropertyViewModel.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import Combine
import Foundation

final class PropertyViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<PropertyTransition, Never>()

    private let propertyNetworkService: PropertyNetworkService
    
    private let propertyId = CurrentValueSubject<String, Never>("")
    private(set) lazy var propertyIdPublisher = propertyId.eraseToAnyPublisher()
    
    private var queries: [String:String] = ["area":"58", "propertyType":"'Flat'"]
    

    init(propertyNetworkService: PropertyNetworkService) {
        self.propertyNetworkService = propertyNetworkService
        super.init()
    }

    func filter() {
        propertyNetworkService.filter(queries: queries)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    debugPrint(error.errorDescription ?? "")
                }
            } receiveValue: { [unowned self] property in
//                self.propertyId.value = property.ownerId
            }
            .store(in: &cancellables)
    }
}
