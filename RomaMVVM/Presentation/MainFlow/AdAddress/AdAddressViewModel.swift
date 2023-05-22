//
//  AdAdressViewModel.swift
//  RomaMVVM
//
//  Created by User on 19.05.2023.
//

import Combine

final class AdAddressViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdAddressTransition, Never>()

    private let model: AdCreatingModel

    private(set) lazy var validationPublisher = validationSubject.eraseToAnyPublisher()
    private lazy var validationSubject = CurrentValueSubject<AddressModel, Never>(.init())

    init(model: AdCreatingModel) {
        self.model = model
        super.init()
    }

    func validateOrt(_ text: String) {
        validationSubject.value.ort = text
        guard let ort = validationSubject.value.ort else {
            return
        }
        validationSubject.value.isOrtValid = false
        validationSubject.value.isOrtValid = ort.count > 3
        validateAddress()
    }

    func validateStreet(_ text: String) {
        validationSubject.value.street = text
        guard let street = validationSubject.value.street else {
            return
        }
        validationSubject.value.isStreetValid = false
        validationSubject.value.isStreetValid = street.count > 3
        validateAddress()
    }

    func validateHouse(_ text: String) {
        validationSubject.value.house = text
        guard let house = validationSubject.value.house else {
            return
        }
        validationSubject.value.isHouseValid = false
        validationSubject.value.isHouseValid = house.count >= 1
        validateAddress()
    }

    private func validateAddress() {
        guard let ort = validationSubject.value.ort,
              let street = validationSubject.value.street,
              let house = validationSubject.value.house
        else {
            return
        }
        let validationText = [ort, street, house].joined(separator: " ")
        validationSubject.value.isValid = validationText == "Kharkiv Khreschatik 21" ? true : false
        guard let houseInt = Int(house),
        validationSubject.value.isValid else {
            return
        }
        model.updateAdCreatingRequestModel(
            ort: ort,
            street: street,
            house: houseInt
        )
    }
    
    func moveToMyHouse() {
        transitionSubject.send(.myHouse)
    }
    
    func moveToAdDetails() {        
        transitionSubject.send(.adDetails(model: self.model))
    }
}
