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

    private var searchParameters: [SearchParam] =
        [
            SearchParam(
                key: PropertyColumn.layout,//.area,
                value: SearchType.equalToInt(parameter: 58)
            ),
            SearchParam(
                key: PropertyColumn.propertyType,
                value: SearchType.equalToString(parameter: "Flat")
            )
        ]

    init(propertyNetworkService: PropertyNetworkService) {
        self.propertyNetworkService = propertyNetworkService
        super.init()
    }

    func filter() {
        propertyNetworkService.search(with: searchParameters)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("Finished")
                case let .failure(error):
                    debugPrint(error.errorDescription ?? "")
                }
            } receiveValue: { [unowned self] property in
                property.forEach { item in
                    NetworkLogger.log(data: item)
                    //                self.propertyId.value = property.ownerId
                }
            }
            .store(in: &cancellables)
    }
}
