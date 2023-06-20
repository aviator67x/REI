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

    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdPhotosTransition, Never>()

    private(set) lazy var isLoadingPublisher = isLoadingSubject.eraseToAnyPublisher()
    private lazy var isLoadingSubject = PassthroughSubject<Bool, Never>()

    private(set) lazy var adCreatingRequestModelPublisher = adCreatingRequestModelSubject.eraseToAnyPublisher()
    private lazy var adCreatingRequestModelSubject = CurrentValueSubject<AdCreatingRequestModel, Never>(.init())

    private(set) lazy var myHousePublisher = myHousesSubject.eraseToAnyPublisher()
    private lazy var myHousesSubject = CurrentValueSubject<[HouseDomainModel], Never>([])

    private var houseImages: [HouseImageModel] = []

    private let housesService: HousesService
    private let userService: UserService

    init(housesService: HousesService, userService: UserService) {
        self.housesService = housesService
        self.userService = userService
    }

    func createAd() {
        guard let userId = userService.user?.id else {
            return
        }
        adCreatingRequestModelSubject.value.ownerId = userId
        isLoadingSubject.send(true)
        housesService.saveAd(houseImages: houseImages, house: adCreatingRequestModelSubject.value)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] completion in
                isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] house in
                debugPrint("Created new ad \(house)")
                let domainHouse = HouseDomainModel(model: house)
                self.myHousesSubject.value.append(domainHouse)
                self.transitionSubject.send(.myHouse)
            })
            .store(in: &cancellables)
    }

    func addImages(_ images: [Data]) {
        houseImages = images.map { HouseImageModel(imageData: $0) }
    }

    func updateAdCreatingRequestModel(
        location: Point,
        ort: String,
        street: String,
        house: Int
    ) {
        adCreatingRequestModelSubject.value.location = location
        adCreatingRequestModelSubject.value.ort = ort
        adCreatingRequestModelSubject.value.street = street
        adCreatingRequestModelSubject.value.house = house
    }

    func updateAdCreatingRequestModel(type: String) {
        adCreatingRequestModelSubject.value.propertyType = type
    }

    func updateAdCreatingRequestModel(number: Int) {
        adCreatingRequestModelSubject.value.roomsNumber = number
    }

    func updateAdCreatingRequestModel(year: Int) {
        adCreatingRequestModelSubject.value.constructionYear = year
    }

    func updateAdCreatingRequestModel(garage: String) {
        adCreatingRequestModelSubject.value.garage = garage
    }

    func updateAdCreatingRequestModel(livingArea: Int) {
        adCreatingRequestModelSubject.value.livingArea = livingArea
    }

    func updateAdCreatingRequestModel(square: Int) {
        adCreatingRequestModelSubject.value.square = square
    }

    func updateAdCreatingRequestModel(price: Int) {
        adCreatingRequestModelSubject.value.price = price
    }

    func updateAdCreatingRequestModel(with item: AdMultiDetailsItem) {
        switch item {
        case let .garage(garage):
            adCreatingRequestModelSubject.value.garage = garage.rawValue
        case let .type(type):
            adCreatingRequestModelSubject.value.propertyType = type.rawValue
        case let .number(number):
            adCreatingRequestModelSubject.value.roomsNumber = number.rawValue
        case let .yearPicker(year):
            adCreatingRequestModelSubject.value.constructionYear = year
        case let .livingAreaSlider(livingArea):
            adCreatingRequestModelSubject.value.livingArea = livingArea
        case let .squareSlider(square):
            adCreatingRequestModelSubject.value.square = square
        case let .priceSlider(price):
            adCreatingRequestModelSubject.value.price = price
        }
    }

    func getUserAds() {
        guard let userId = userService.user?.id else {
            return
        }
        isLoadingSubject.send(true)
        housesService.getUserAds(ownerId: userId)
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveValue: { _, houses in
                self.isLoadingSubject.send(false)
                self.myHousesSubject.value = houses
            })
            .store(in: &cancellables)
    }

    func delete(_ item: MyHouseItem) {
        switch item {
        case let .photo(house):
            let id = house.id
            isLoadingSubject.send(true)
            housesService.deleteAd(with: id)
                .receive(on: DispatchQueue.main)
                .sinkWeakly(self, receiveCompletion: { (self, completion) in
                    self.isLoadingSubject.send(false)
                    switch completion {
                    case .finished:
                        self.getUserAds()
                    case let .failure(error):
                        debugPrint(error.localizedDescription)
                    }
                })
                .store(in: &cancellables)
        }
    }
}
