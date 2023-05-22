//
//  AdAddressModel.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import Combine
import Foundation

final class AdCreatingModel {
    private var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var isLoadingPublisher = isLoadingSubject.eraseToAnyPublisher()
    private lazy var isLoadingSubject = PassthroughSubject<Bool, Never>()
    
    private(set) lazy var adCreatingPublisher = adCreatingRequetSubject.eraseToAnyPublisher()
    private lazy var adCreatingRequetSubject = CurrentValueSubject<AdCreatingRequestModel, Never>(.init())
    
    private let housesService: HousesService
    
    init(housesService: HousesService) {
        self.housesService = housesService
        
        setupBinding()
    }
    
   private func setupBinding() {
        adCreatingRequetSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
//                self.updateSearchFilters()
            })
            .store(in: &cancellables)
    }
    
    func updateAdCreatingRequestModel(
        ort: String,
        street: String,
        house: Int
    ) {
        adCreatingRequetSubject.value.ort = ort
        adCreatingRequetSubject.value.street = street
        adCreatingRequetSubject.value.house = house
    }
}
