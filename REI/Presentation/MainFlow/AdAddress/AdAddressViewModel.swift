//
//  AdAdressViewModel.swift
//  REI
//
//  Created by User on 19.05.2023.
//

import Combine
import CoreLocation

final class AdAddressViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdAddressTransition, Never>()

    private(set) lazy var validationPublisher = validationSubject.eraseToAnyPublisher()
    private lazy var validationSubject = CurrentValueSubject<AddressModel, Never>(.init())

    private let model: AdCreatingModel

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

    func moveToMyHouse() {
        transitionSubject.send(.myHouse)
    }

    func moveToAdDetails() {
        transitionSubject.send(.adDetails(model: model))
    }
}

// MARK: - private extension
private extension AdAddressViewModel {
    func validateAddress() {
        guard let ort = validationSubject.value.ort,
              let street = validationSubject.value.street,
              let house = validationSubject.value.house,
              validationSubject.value.isOrtValid,
              validationSubject.value.isStreetValid,
              validationSubject.value.isHouseValid
        else {
            return
        }
        let address = [ort, street, house].joined(separator: ", ")

        guard let houseInt = Int(house)
        else {
            return
        }

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { [weak self] placemarks, _ in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                self?.validationSubject.value.isValid = false
                return
            }
            self?.validationSubject.value.isValid = true
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let point = Point(type: "Point", coordinates: [lat, long])
            self?.model.updateAdCreatingRequestModel(
                location: point,
                ort: ort,
                street: street,
                house: houseInt
            )
        }
    }
}
