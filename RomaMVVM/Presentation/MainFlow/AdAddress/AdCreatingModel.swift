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

    private(set) lazy var houseRequestModelPublisher = houseRequestModelSubject.eraseToAnyPublisher()
    private lazy var houseRequestModelSubject = CurrentValueSubject<AdCreatingRequestModel, Never>(.init())
    
    private var houseImages: [HouseImageModel] = []

    private let housesService: HousesService

    init(housesService: HousesService) {
        self.housesService = housesService
    }
    
    func createAd() {
        housesService.saveAd(houseImages: houseImages, house: houseRequestModelSubject.value)
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
        houseRequestModelSubject.value.ort = ort
        houseRequestModelSubject.value.street = street
        houseRequestModelSubject.value.house = house
    }

    func updateAdCreatingRequestModel(with item: AdMultiDetailsItem) {
        switch item {
        case let .garage(garage):
            houseRequestModelSubject.value.garage = garage.rawValue
        case let .type(type):
            houseRequestModelSubject.value.propertyType = type.rawValue
        case let .number(number):
            houseRequestModelSubject.value.roomsNumber = number.rawValue
        case let .yearPicker(year):
            houseRequestModelSubject.value.constructionYear = year
        case let .livingAreaSlider(livingArea):
            houseRequestModelSubject.value.livingArea = livingArea
        case let .squareSlider(square):
            houseRequestModelSubject.value.square = square
        case let .priceSlider(price):
            houseRequestModelSubject.value.price = price
        }
    }
}
