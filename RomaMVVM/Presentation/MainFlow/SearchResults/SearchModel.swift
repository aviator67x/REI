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
    
    private(set) lazy var searchParametersPublisher = searchParametersSubject.eraseToAnyPublisher()
    private lazy var searchParametersSubject = CurrentValueSubject<[SearchParam], Never>([])

    private(set) lazy var housesPublisher = housesSubject.eraseToAnyPublisher()
    private lazy var housesSubject = CurrentValueSubject<[HouseDomainModel], Never>([])

    private var isPaginationInProgress = false
    private var hasMoreToLoad = true
    private var offset = 0
    private var pageSize = 2

    init(housesService: HousesService) {
        self.housesService = housesService
    }

    func updateSearchRequestModel(distance: SearchRequestModel.Distance) {
        searchRequestModel.distance
//        let distanceParam = SearchParam(
//            key: .distance,
//            value: .equalToString(parameter: distance)
//        )
//        if let existingIndex = searchParametersSubject.value.firstIndex(where: {$0.key == .distance}) {
//            searchParametersSubject.value.remove(at: existingIndex)
//        }
//        searchParametersSubject.value.append(distanceParam)
    }

    func updateSearchRequestModel(minPrice: String) {
        searchRequestModel.minPrice = minPrice
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
        switch maxPriceParam.value {
        case .equalToString(parameter: _), .equalToInt(parameter: _), .more(than: _):
            break
        case .less(than: _):
            if let existingIndex = searchParametersSubject.value.firstIndex(where: {$0.key == .price}) {
                searchParametersSubject.value.remove(at: existingIndex)
            }
        }
        searchParametersSubject.value.append(maxPriceParam)
    }

    func updateSearchRequestModel(propertyType: SearchRequestModel.PropertyType) {
//        searchRequestModel.propertyType = propertyType
//        let typeParam = SearchParam(
//            key: .propertyType,
//            value: .equalToString(parameter: propertyType)
//        )
//        if let existingIndex = searchParametersSubject.value.firstIndex(where: {$0.key == .propertyType}) {
//            searchParametersSubject.value.remove(at: existingIndex)
//        }
//        searchParametersSubject.value.append(typeParam)
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
        switch minSquareParam.value {
        case .equalToInt(parameter: _), .less(than: _), .equalToString(parameter: _):
            break
        case .more(than: _):
            if let existingIndex = searchParametersSubject.value.firstIndex(where: {$0.key == .square}) {
                searchParametersSubject.value.remove(at: existingIndex)
            }
        }
        searchParametersSubject.value.append(minSquareParam)
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
        switch maxSquareParam.value {
        case .equalToString(parameter: _), .equalToInt(parameter: _), .more(than: _):
            break
        case .less(than: _):
            if let existingIndex = searchParametersSubject.value.firstIndex(where: {$0.key == .square}) {
                searchParametersSubject.value.remove(at: existingIndex)
            }
        }
        searchParametersSubject.value.append(maxSquareParam)
    }

    func updateSearchRequestModel(roomsNumber: SearchRequestModel.NumberOfRooms) {
//        searchRequestModel.roomsNumber = roomsNumber
//        guard let character = roomsNumber.first,
//              let number = Int(String(character)) else { return }
//        let roomsNumberParam = SearchParam(
//            key: .roomsNumber,
//            value: .equalToInt(parameter: number)
//        )
//        if let existingIndex = searchParametersSubject.value.firstIndex(where: {$0.key == .roomsNumber}) {
//            searchParametersSubject.value.remove(at: existingIndex)
//        }
//        searchParametersSubject.value.append(roomsNumberParam)
    }

    func updateSearchRequestModel(constructionYear: String) {
        searchRequestModel.constructionYear = constructionYear
        let constructionYearParam = SearchParam(
            key: .constructionYear,
            value: .equalToString(parameter: constructionYear)
        )
        if let existingIndex = searchParametersSubject.value.firstIndex(where: {$0.key == .constructionYear}) {
            searchParametersSubject.value.remove(at: existingIndex)
        }
        searchParametersSubject.value.append(constructionYearParam)
    }

    func updateSearchRequestModel(parkingType: String) {
        searchRequestModel.garage = parkingType
        let garageParam = SearchParam(
            key: .garage,
            value: .equalToString(parameter: parkingType)
        )
        if let existingIndex = searchParametersSubject.value.firstIndex(where: {$0.key == .garage}) {
            searchParametersSubject.value.remove(at: existingIndex)
        }
        searchParametersSubject.value.append(garageParam)
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
        print("Param\(searchParametersSubject.value)")
//        isLoadingSubject.send(true)
//        housesService.searchHouses(searchParametersSubject.value)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    self.isLoadingSubject.send(false)
//                case let .failure(error):
//                    debugPrint(error.localizedDescription)
//                }
//            }, receiveValue: { [unowned self] houses in
//                self.housesSubject.value = houses
//                self.searchParametersSubject.value = []
//                self.hasMoreToLoad = false
//            })
//            .store(in: &cancellables)
    }
}
