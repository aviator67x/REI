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

    private var searchRequestModel: SearchRequestModel = .init()
    @Published var searchParameters: [SearchParam] = []

    @Published var houses: [HouseDomainModel] = []

    private var isPaginationInProgress = false
    private var hasMoreToLoad = true
    private var offset = 0
    private var pageSize = 2

    init(housesService: HousesService) {
        self.housesService = housesService
    }

    func updateSearchRequestModel(distance: String) {
        searchRequestModel.distance = distance
        let distanceParam = SearchParam(
            key: .distance,
            value: .equalToString(parameter: distance)
        )
        searchParameters.append(distanceParam)
    }

    func updateSearchRequestModel(minPrice: String) {
        searchRequestModel.minPrice = minPrice
        guard let minPriceInt = Int(minPrice) else {
            return
        }
        let minPriceParam = SearchParam(
            key: .price,
            value: .more(than: minPriceInt)
        )
        searchParameters.append(minPriceParam)
    }

    func updateSearchRequestModel(maxPrice: String) {
        searchRequestModel.maxPrice = maxPrice
        guard let maxPriceInt = Int(maxPrice) else {
            return
        }
        let maxPriceParam = SearchParam(
            key: .price,
            value: .less(than: maxPriceInt)
        )
        searchParameters.append(maxPriceParam)
    }

    func updateSearchRequestModel(propertyType: String) {
        searchRequestModel.propertyType = propertyType
        let typeParam = SearchParam(
            key: .propertyType,
            value: .equalToString(parameter: propertyType)
        )
        searchParameters.append(typeParam)
    }

    func updateSearchRequestModel(minSquare: String) {
        searchRequestModel.minSquare = minSquare
        guard let minSquareParamInt = Int(minSquare) else {
            return
        }
        let minSquareParam = SearchParam(
            key: .square,
            value: .more(than: minSquareParamInt)
        )
        searchParameters.append(minSquareParam)
    }

    func updateSearchRequestModel(maxSquare: String) {
        searchRequestModel.maxSquare = maxSquare
        guard let maxSquareParamInt = Int(maxSquare) else {
            return
        }
        let maxSquareParam = SearchParam(
            key: .square,
            value: .less(than: maxSquareParamInt)
        )
        searchParameters.append(maxSquareParam)
    }

    func updateSearchRequestModel(roomsNumber: String) {
        searchRequestModel.roomsNumber = roomsNumber
        guard let character = roomsNumber.first,
              let number = Int(String(character)) else { return }
        let roomsNumberParam = SearchParam(
            key: .roomsNumber,
            value: .equalToInt(parameter: number)
        )
        searchParameters.append(roomsNumberParam)
    }

    func updateSearchRequestModel(constructionYear: String) {
        searchRequestModel.constructionYear = constructionYear
        let constructionYearParam = SearchParam(
            key: .constructionYear,
            value: .equalToString(parameter: constructionYear)
        )
        searchParameters.append(constructionYearParam)
    }

    func updateSearchRequestModel(parkingType: String) {
        searchRequestModel.garage = parkingType
        let garageParam = SearchParam(
            key: .garage,
            value: .equalToString(parameter: parkingType)
        )
        searchParameters.append(garageParam)
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
                self.houses.append(contentsOf: data)
                self.offset += data.count
                self.hasMoreToLoad = offset >= pageSize
                self.isPaginationInProgress = false
            })
            .store(in: &cancellables)
    }

    func executeSearch() {
        isLoadingSubject.send(true)
        housesService.searchHouses(searchParameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoadingSubject.send(false)
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] houses in
                self.houses = houses
                self.searchParameters = []
                self.hasMoreToLoad = false
            })
            .store(in: &cancellables)
    }
}
