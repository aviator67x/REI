//
//  HouseNetworkService.swift
//  RomaMVVM
//
//  Created by User on 06.04.2023.
//

import Combine
import Foundation

protocol HousesNetworkService {
    func getHouses(pageSize: Int, skip: Int) -> AnyPublisher<[HouseResponseModel], NetworkError>
    func searchHouses(with parameters: [SearchParam]) -> AnyPublisher<[HouseResponseModel], NetworkError>
    func saveHouseImage(image: [MultipartItem]) -> AnyPublisher<SaveHouseImageResponseModel, NetworkError>
    func saveAd(house: AdCreatingRequestModel) -> AnyPublisher<HouseResponseModel, NetworkError>
    func getHousesCount() -> AnyPublisher<Int, NetworkError>
}

final class HousesNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == HouseEndPoint {
    let housesProvider: NetworkProvider

    init(housesProvider: NetworkProvider) {
        self.housesProvider = housesProvider
    }
}

extension HousesNetworkServiceImpl: HousesNetworkService {
    func getHousesCount() -> AnyPublisher<Int, NetworkError> {
        return housesProvider.execute(endpoint: .housesCount)
    }
    
    func getHouses(pageSize: Int, skip: Int) -> AnyPublisher<[HouseResponseModel], NetworkError> {
        return housesProvider.execute(endpoint: .getHouses(pageSize: pageSize, skip: skip))
    }

    func searchHouses(with parameters: [SearchParam]) -> AnyPublisher<[HouseResponseModel], NetworkError> {
        return housesProvider.execute(endpoint: .filter(with: parameters))
    }
    
    func saveHouseImage(image: [MultipartItem]) -> AnyPublisher<SaveHouseImageResponseModel, NetworkError> {
        return housesProvider.execute(endpoint: .saveImage(image))
    }
    
    func saveAd(house: AdCreatingRequestModel) -> AnyPublisher<HouseResponseModel, NetworkError> {
        return housesProvider.execute(endpoint: .saveAd(house))
    }
}
