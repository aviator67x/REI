//
//  AdCreatingViewModel.swift
//  RomaMVVM
//
//  Created by User on 15.05.2023.
//

import Combine

final class AdCreatingViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdCreatingTransition, Never>()
    
    private(set) lazy var adCreatingPublisher = adCreatingRequetSubject.eraseToAnyPublisher()
    private lazy var adCreatingRequetSubject = CurrentValueSubject<AdCreatingRequestModel, Never>(.init())
    
    private let model: AdCreatingModel
    
    private var ort = ""
    private var street = ""
    private var house = ""
    
    private(set) lazy var validationPublisher = validationSubject.eraseToAnyPublisher()
    private lazy var validationSubject = PassthroughSubject<AddressModel, Never>()
    
    private var addressCellModel = AddressModel()
    
    init(model: AdCreatingModel) {
        self.model = model
        super.init()
    }
    func updateOrt(ort: String) {
        self.ort = ort
        addressCellModel.ort = ort
        adCreatingRequetSubject.value.ort = ort
    }
    
    func updateStreet(street: String) {
        addressCellModel.street = street
        self.street = street
    }
    
    func updateHouse(house: String) {
        self.house = house
        addressCellModel.house = house
        adCreatingRequetSubject.value.street = [self.street, self.house].joined(separator: " ")
        validateAddress()
    }
    
    func validateAddress() {
        let validationText = [ort, street, house].joined(separator: " ")
        if validationText == "Kharkiv Khreschatik 21" {
            addressCellModel.isValid = true
        } else {
            addressCellModel.isValid = false
        }
        validationSubject.send(addressCellModel)
    }
}
