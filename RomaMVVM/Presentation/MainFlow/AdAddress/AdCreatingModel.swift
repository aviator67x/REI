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
    
    private var houseImages: [HouseImageModel] = []

    private let housesService: HousesService

    init(housesService: HousesService) {
        self.housesService = housesService

        setupBinding()
    }

    private func setupBinding() {
        adCreatingRequetSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
//ToDo: make request
            })
            .store(in: &cancellables)
    }
    
    func createAd() {
        housesService.saveAd(houseImages: houseImages, house: adCreatingRequetSubject.value)
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] house in
                debugPrint(house)
            })
            .store(in: &cancellables)
    }
    
    func addImages(_ images: [Data]) {
        houseImages = images.map { HouseImageModel(imageData: $0)}
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

    func updateAdCreatingRequestModel(with item: AdMultiDetailsItem) {
        switch item {
        case let .garage(garage):
            adCreatingRequetSubject.value.garage = garage.rawValue
        case let .type(type):
            adCreatingRequetSubject.value.propertyType = type.rawValue
        case let .number(number):
            adCreatingRequetSubject.value.roomsNumber = number.rawValue
        case let .yearPicker(year):
            adCreatingRequetSubject.value.constructionYear = year
        case let .livingAreaSlider(livingArea):
            adCreatingRequetSubject.value.livingArea = livingArea
        case let .squareSlider(square):
            adCreatingRequetSubject.value.square = square
        case let .priceSlider(price):
            adCreatingRequetSubject.value.price = price
        }
    }
}
