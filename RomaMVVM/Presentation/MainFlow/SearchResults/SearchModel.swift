//
//  FindModel.swift
//  RomaMVVM
//
//  Created by User on 14.04.2023.
//

import Combine
import Foundation

final class SearchModel {
    private var cancellables = Set<AnyCancellable>()

    private(set) lazy var isLoadingPublisher = isLoadingSubject.eraseToAnyPublisher()
    private lazy var isLoadingSubject = PassthroughSubject<Bool, Never>()

    private let housesService: HousesService
    private let userService: UserService

    private(set) lazy var searchParametersPublisher = searchParametersSubject.eraseToAnyPublisher()
    private lazy var searchParametersSubject = CurrentValueSubject<[SearchParam], Never>([])

    private(set) lazy var housesPublisher = housesSubject.eraseToAnyPublisher()
    private lazy var housesSubject = CurrentValueSubject<[HouseDomainModel], Never>([])

    private(set) lazy var searchRequestModelPublisher = searchRequestModelSubject.eraseToAnyPublisher()
    private lazy var searchRequestModelSubject = CurrentValueSubject<SearchRequestModel, Never>(.init())

    private var isPaginationInProgress = false
    private var hasMoreToLoad = true
    private var offset = 0
    private var pageSize = 5
    private var housesCount = 0

    private var favouriteHouses: [String] = []

    init(housesService: HousesService, userService: UserService) {
        self.housesService = housesService
        self.userService = userService
        setupBinding()
    }

    func setupBinding() {
        searchRequestModelSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.updateSearchFilters()
            })
            .store(in: &cancellables)
    }

    func getFavouriteHouses() {
        userService.user?.favouriteHouses?.forEach { house in
            favouriteHouses.append(house.id)
        }
    }

    func addToFavouritiesHouse(with id: String) {
        if !favouriteHouses.contains(id) {
            favouriteHouses.append(id)
        }
        userService.addToFavourities(houses: favouriteHouses)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    func updateSearchFilters() {
        searchParametersSubject.value = []

        if let distance = searchRequestModelSubject.value.distance {
            searchParametersSubject.value
                .append(.init(key: .distance, value: .equalToInt(parameter: distance.rawValue)))
        }

        if let minPrice = searchRequestModelSubject.value.minPrice {
            searchParametersSubject.value.append(.init(key: .price, value: .more(than: minPrice)))
        }

        if let maxPrice = searchRequestModelSubject.value.maxPrice {
            searchParametersSubject.value.append(.init(key: .price, value: .less(than: maxPrice)))
        }

        if let propertyType = searchRequestModelSubject.value.propertyType {
            searchParametersSubject.value
                .append(.init(key: .propertyType, value: .equalToString(parameter: propertyType.rawValue)))
        }

        if let minSquare = searchRequestModelSubject.value.minSquare {
            searchParametersSubject.value.append(.init(key: .square, value: .more(than: minSquare)))
        }

        if let maxSquare = searchRequestModelSubject.value.maxSquare {
            searchParametersSubject.value.append(.init(key: .square, value: .less(than: maxSquare)))
        }

        if let numberOfRooms = searchRequestModelSubject.value.roomsNumber {
            searchParametersSubject.value
                .append(.init(key: .roomsNumber, value: .equalToInt(parameter: numberOfRooms.rawValue)))
        }

        if let constructionYear = searchRequestModelSubject.value.constructionYear {
            searchParametersSubject.value
                .append(.init(key: .roomsNumber, value: .equalToInt(parameter: constructionYear.rawValue)))
        }

        if let garage = searchRequestModelSubject.value.garage {
            searchParametersSubject.value
                .append(.init(key: .roomsNumber, value: .equalToString(parameter: garage.rawValue)))
        }
    }

    func cleanSearchRequestModel() {
        searchRequestModelSubject.value = SearchRequestModel.empty
        hasMoreToLoad = true
        offset = 0
        housesSubject.value = []
        loadHouses()
    }

    func updateSearchRequestModel(distance: Distance) {
        searchRequestModelSubject.value.distance = distance
    }

    func updateSearchRequestModel(minPrice: String) {
        searchRequestModelSubject.value.minPrice = Int(minPrice)
    }

    func updateSearchRequestModel(maxPrice: String) {
        searchRequestModelSubject.value.maxPrice = Int(maxPrice)
    }

    func updateSearchRequestModel(propertyType: PropertyType) {
        searchRequestModelSubject.value.propertyType = propertyType
    }

    func updateSearchRequestModel(minSquare: String) {
        searchRequestModelSubject.value.minSquare = Int(minSquare)
    }

    func updateSearchRequestModel(maxSquare: String) {
        searchRequestModelSubject.value.maxSquare = Int(maxSquare)
    }

    func updateSearchRequestModel(roomsNumber: NumberOfRooms) {
        searchRequestModelSubject.value.roomsNumber = roomsNumber
    }

    func updateSearchRequestModel(constructionYear: PeriodOfBuilding) {
        searchRequestModelSubject.value.constructionYear = constructionYear
    }

    func updateSearchRequestModel(parkingType: Garage) {
        searchRequestModelSubject.value.garage = parkingType
    }

    func loadHouses() {
        guard !isPaginationInProgress//,
//              hasMoreToLoad
        else {
            return
        }
        isPaginationInProgress = true
        isLoadingSubject.send(true)
        housesService.getHouses(pageSize: pageSize, offset: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] data in
                NetworkLogger.log(data: data)
                self.housesSubject.value.append(contentsOf: data)
                self.offset += data.count
                self.hasMoreToLoad = offset >= pageSize
                self.isPaginationInProgress = false
            })
            .store(in: &cancellables)
    }

    func executeSearch() {
        isLoadingSubject.send(true)
        housesService.searchHouses(searchParametersSubject.value)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoadingSubject.send(false)
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] houses in
                self.housesSubject.value = houses
                self.searchRequestModelSubject.value = SearchRequestModel.empty
                self.hasMoreToLoad = false
            })
            .store(in: &cancellables)
    }
}
