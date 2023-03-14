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
    
    private var searchKey: PropertyColumn?
    private var searchValue: SearchType?
    
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
    // MARK: - Lifecycle
    init(propertyNetworkService: PropertyNetworkService) {
        self.propertyNetworkService = propertyNetworkService
        super.init()
    }
}

// MARK: - extension
extension PropertyViewModel {
    func addSearchKey(_ key: PropertyColumn) {
        searchKey = key
    }
    
    func addSearchValue(_ value: SearchType) {
        searchValue = value
    }

    func filter() {
        guard let searchKey = searchKey,
              let searchValue = searchValue else { return }
        let searchParameters = [SearchParam(key: searchKey, value: searchValue)]
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
