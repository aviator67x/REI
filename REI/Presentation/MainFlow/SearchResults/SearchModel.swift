//
//  FindModel.swift
//  REI
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

    private(set) lazy var searchRequestModelPublisher = searchRequestModelSubject.eraseToAnyPublisher()
    private lazy var searchRequestModelSubject = CurrentValueSubject<SearchRequestModel, Never>(.init())

    private var sortParameters: [String] = []

    private(set) lazy var housesPublisher = housesSubject.eraseToAnyPublisher()
    private lazy var housesSubject = CurrentValueSubject<[HouseDomainModel], Never>([])

    private(set) lazy var favouriteHousesIdPublisher = favouriteHousesIdSubject.eraseToAnyPublisher()
    private lazy var favouriteHousesIdSubject = CurrentValueSubject<[String], Never>([])

    private(set) lazy var housesCountPublisher = housesCountSubject.eraseToAnyPublisher()
    private lazy var housesCountSubject = PassthroughSubject<Int, Never>()

    private(set) lazy var filteredHousesCountPublisher = filteredHousesCountSubject.eraseToAnyPublisher()
    private lazy var filteredHousesCountSubject = PassthroughSubject<Int, Never>()

    private(set) lazy var availableInPoligonHouesesPublisher = availableInPoligonHouesesSubject.eraseToAnyPublisher()
    private lazy var availableInPoligonHouesesSubject = PassthroughSubject<[HouseDomainModel], Never>()

    private var isPaginationInProgress = false
//    private var hasMoreToLoad = true
    private var offset = 0
    private var pageSize = 10
    private var housesCount = 0

    // MARK: - Life cycle
    init(housesService: HousesService, userService: UserService) {
        self.housesService = housesService
        self.userService = userService

        setupBinding()
    }

    // MARK: - Private methods
    private func setupBinding() {
        searchRequestModelSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.updateSearchFilters()
                self.getFilteredHousesCount()
            })
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension SearchModel {
    func getFavouriteHouses() {
        var ids: [String] = []
        isLoadingSubject.send(true)
        userService.getFavouriteHouses()
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveCompletion: { (self, completion) in
                self.isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    self.userService.user?.favouriteHouses?.forEach { house in
                        ids.append(house.id)
                    }
                    self.favouriteHousesIdSubject.value = ids
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            })
            .store(in: &cancellables)
    }

    func favouriteHouses() -> [HouseDomainModel]? {
        return userService.user?.favouriteHouses
    }

    func editFavouriteHouses(with id: String) {
        if let index = favouriteHousesIdSubject.value.firstIndex(of: id) {
            favouriteHousesIdSubject.value.remove(at: index)
        } else {
            favouriteHousesIdSubject.value.append(id)
        }

        isLoadingSubject.send(true)
        userService.addToFavourities(houses: favouriteHousesIdSubject.value)
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self) { (self, completion) in
                self.isLoadingSubject.send(false)
                if case let .failure(error) = completion {
                    debugPrint(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
//            .sink(receiveCompletion: { completion in
//                self.isLoadingSubject.send(false)
//                if case let .failure(error) = completion {
//                    debugPrint(error.localizedDescription)
//                }
//            }, receiveValue: { _ in })
//            .store(in: &cancellables)
    }

    func updateSortParameters(parameters: [String]) {
        offset = 0
        sortParameters = parameters
    }

    func updateSearchFilters() {
        searchParametersSubject.value = []

        if let distance = searchRequestModelSubject.value.distanceOnSphere {
            searchParametersSubject.value
                .append(.init(key: .distanceOnSphere, value: .within(distance: distance)))
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
                .append(.init(key: .constructionYear, value: .more(than: constructionYear.rawValue)))
        }

        if let garage = searchRequestModelSubject.value.garage {
            searchParametersSubject.value
                .append(.init(key: .garage, value: .equalToString(parameter: garage.rawValue)))
        }
    }

    func saveSearchFilters() {
        let params = searchParametersSubject.value
        if let parametersData = try? JSONEncoder().encode(params) {
            // Saving to UserDeafaults
            UserDefaults.standard.set(parametersData, forKey: "searchParameters")
        }
    }

    func cleanSearchRequestModel() {
        searchRequestModelSubject.value = SearchRequestModel.empty
//        hasMoreToLoad = true
        offset = 0
        housesSubject.value = []
    }

    func updateSearchParameters(_ parameters: [SearchParam]) {
        offset = 0
        searchParametersSubject.value = parameters
        housesSubject.value = []
    }

    func updateSearchRequestModel(ortPolygon: String) {
        searchRequestModelSubject.value.ortPolygon = ortPolygon
    }

    func updateSearchRequestModel(distance: String) {
        searchRequestModelSubject.value.distanceOnSphere = distance
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

    func loadMockHouses() {
        housesService.getMockHouses()
            .sinkWeakly(self, receiveValue: { (self, houses) in
                self.housesSubject.value = houses
            })
            .store(in: &cancellables)
    }

    func loadHouses() {
        housesService.getHousesFromCoreData()
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveCompletion: { (self, _) in
                self.loadHousesAPI()
            }, receiveValue: { (self, houses) in
                guard let houses = houses else {
                    return
                }
                self.housesSubject.value = houses
            })
            .store(in: &cancellables)
    }

    func loadHousesAPI() {
        guard !isPaginationInProgress
//              hasMoreToLoad
        else {
            return
        }
        let searchParams = searchParametersSubject.value.isEmpty ? nil : searchParametersSubject.value
        let sortParams = sortParameters.isEmpty ? nil : sortParameters
        isPaginationInProgress = true
        isLoadingSubject.send(true)
        housesService.getHouses(
            pageSize: pageSize,
            offset: offset,
            searchParameters: searchParams,
            sortParameters: sortParams
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [unowned self] completion in
            self.isPaginationInProgress = false
            self.isLoadingSubject.send(false)
            if case let .failure(error) = completion {
                debugPrint(error.localizedDescription)
            }
        }, receiveValue: { [unowned self] data in
            NetworkLogger.log(data: data)
            if offset == 0 {
                self.housesSubject.value = data
            } else {
                self.housesSubject.value.append(contentsOf: data)
            }
            self.offset += data.count
//            self.hasMoreToLoad = offset >= pageSize

        })
        .store(in: &cancellables)
    }

    func getHousesCount() {
        isLoadingSubject.send(true)
        housesService.getHousesCount()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [unowned self] count in
                self.housesCountSubject.send(count)
            }
            .store(in: &cancellables)
    }

    func getAvailableHouses(in poligon: String) {
        isLoadingSubject.send(true)
        housesService.getAvailableHouses(in: poligon)
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveCompletion: { (self, completion) in
                self.isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            }, receiveValue: { (self, houses) in
                self.availableInPoligonHouesesSubject.send(houses)
            })
            .store(in: &cancellables)
    }

    func getFilteredHousesCount() {
        isLoadingSubject.send(true)
        let filters = searchParametersSubject.value
        housesService.getFilteredHousesCount(filters)
            .receive(on: DispatchQueue.main)
            .sinkWeakly(
                self,
                receiveCompletion: { (self, completion) in
                    self.isLoadingSubject.send(false)
                    if case let .failure(error) = completion {
                        debugPrint(error.localizedDescription)
                    }
                },
                receiveValue: { (self, count) in
                    self.filteredHousesCountSubject.send(count)
                    self.housesCountSubject.send(count)
                }
            )
            .store(in: &cancellables)
    }

    func updateOffset() {
        offset = 0
    }
}
