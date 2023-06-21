//
//  AdAdressViewModel.swift
//  RomaMVVM
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
              let house = validationSubject.value.house
        else {
            return
        }
        let address = [ort, street, house].joined(separator: " ")
        validationSubject.value.isValid = address == "Broek-Op-Langedijk Dorpstraat 41" ? true : false
        guard let houseInt = Int(house),
              validationSubject.value.isValid
        else {
            return
        }

        getHouseLocation(from: address)
            .sinkWeakly(self, receiveValue: { (self, location) in
                let pointLocation = Point(type: "Point", coordinates: [location.coordinates[0], location.coordinates[1]])
                self.model.updateAdCreatingRequestModel(
                    location: pointLocation,
                    ort: ort,
                    street: street,
                    house: houseInt
                )
            })
            .store(in: &cancellables)
    }

    func getHouseLocation(from address: String) -> AnyPublisher<Point, Never> {
        let geoCoder = CLGeocoder()
        let publisher = PassthroughSubject<Point, Never>()
        geoCoder.geocodeAddressString(address) { [weak self] placemarks, _ in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                return
            }
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let point = Point(type: "Point", coordinates: [lat, long])
            publisher.send(point)
        }
        return publisher
            .eraseToAnyPublisher()
    }
}
