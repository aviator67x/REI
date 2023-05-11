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

    private var isPaginationInProgress = false
    private var hasMoreToLoad = true
    private var offset = 0
    private var pageSize = 2

    private var favouriteHouses: [String] = []
    var searchRequestModel: SearchRequestModel = .init() {
        didSet {
            updateSearchFilters()
        }
    }

    init(housesService: HousesService, userService: UserService) {
        self.housesService = housesService
        self.userService = userService
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

        if let distance = searchRequestModel.distance {
            searchParametersSubject.value
                .append(.init(key: .distance, value: .equalToInt(parameter: distance.rawValue)))
        }

        if let minPrice = searchRequestModel.minPrice {
            searchParametersSubject.value.append(.init(key: .price, value: .more(than: minPrice)))
        }

        if let maxPrice = searchRequestModel.maxPrice {
            searchParametersSubject.value.append(.init(key: .price, value: .less(than: maxPrice)))
        }

        if let propertyType = searchRequestModel.propertyType {
            searchParametersSubject.value
                .append(.init(key: .propertyType, value: .equalToString(parameter: propertyType.rawValue)))
        }

        if let minSquare = searchRequestModel.minSquare {
            searchParametersSubject.value.append(.init(key: .square, value: .more(than: minSquare)))
        }

        if let maxSquare = searchRequestModel.maxSquare {
            searchParametersSubject.value.append(.init(key: .square, value: .less(than: maxSquare)))
        }

        if let numberOfRooms = searchRequestModel.roomsNumber {
            searchParametersSubject.value
                .append(.init(key: .roomsNumber, value: .equalToInt(parameter: numberOfRooms.rawValue)))
        }

        if let constructionYear = searchRequestModel.constructionYear {
            searchParametersSubject.value
                .append(.init(key: .roomsNumber, value: .equalToInt(parameter: constructionYear.rawValue)))
        }

        if let garage = searchRequestModel.garage {
            searchParametersSubject.value
                .append(.init(key: .roomsNumber, value: .equalToString(parameter: garage.rawValue)))
        }
    }

    func cleanSearchRequestModel() {
        searchRequestModel = SearchRequestModel.empty
    }

    func updateSearchRequestModel(distance: Distance) {
        searchRequestModel.distance = distance
    }

    func updateSearchRequestModel(minPrice: String) {
        searchRequestModel.minPrice = Int(minPrice)
    }

    func updateSearchRequestModel(maxPrice: String) {
        searchRequestModel.maxPrice = Int(maxPrice)
    }

    func updateSearchRequestModel(propertyType: PropertyType) {
        searchRequestModel.propertyType = propertyType
    }

    func updateSearchRequestModel(minSquare: String) {
        searchRequestModel.minSquare = Int(minSquare)
    }

    func updateSearchRequestModel(maxSquare: String) {
        searchRequestModel.maxSquare = Int(maxSquare)
    }

    func updateSearchRequestModel(roomsNumber: NumberOfRooms) {
        searchRequestModel.roomsNumber = roomsNumber
    }

    func updateSearchRequestModel(constructionYear: PeriodOfBuilding) {
        searchRequestModel.constructionYear = constructionYear
    }

    func updateSearchRequestModel(parkingType: Garage) {
        searchRequestModel.garage = parkingType
    }

    func loadHouses() {
        guard hasMoreToLoad,
              !isPaginationInProgress
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
                self.hasMoreToLoad = false
            })
            .store(in: &cancellables)
    }
}
