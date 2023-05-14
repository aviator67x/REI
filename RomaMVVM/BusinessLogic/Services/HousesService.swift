//
//  HousesService.swift
//  RomaMVVM
//
//  Created by User on 19.04.2023.
//

import Combine
import Foundation

enum HousesServiceError: Error {
    case networking(NetworkError)
    case noHouses
}

protocol HousesService {
    func getHouses(pageSize: Int, offset: Int) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func searchHouses(_ parameters: [SearchParam]) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func update(house: UpdateHouseFavouriteParameterRequestModel, houseId: String) -> AnyPublisher<HouseDomainModel, HousesServiceError>
}

final class HousesServiceImpl: HousesService {
    private let housesNetworkService: HousesNetworkService

    init(housesNetworkService: HousesNetworkService) {
        self.housesNetworkService = housesNetworkService
    }

    func getHouses(pageSize: Int, offset: Int) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        housesNetworkService.getHouses(pageSize: pageSize, skip: offset)
            .mapError { HousesServiceError.networking($0) }
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
            .eraseToAnyPublisher()
    }

    func searchHouses(_ parameters: [SearchParam]) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        housesNetworkService.searchHouses(with: parameters)
            .mapError { HousesServiceError.networking($0) }
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
            .eraseToAnyPublisher()
    }

    func update(house: UpdateHouseFavouriteParameterRequestModel, houseId: String) -> AnyPublisher<HouseDomainModel, HousesServiceError> {
        return housesNetworkService.updateHouse(house, houseId: houseId)
            .mapError { HousesServiceError.networking($0) }
            .map { house in
                HouseDomainModel(model: house)
            }
            .eraseToAnyPublisher()
    }
}
