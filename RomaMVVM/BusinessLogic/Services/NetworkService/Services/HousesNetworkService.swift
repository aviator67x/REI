//
//  HouseNetworkService.swift
//  RomaMVVM
//
//  Created by User on 06.04.2023.
//

import Foundation
import Combine

protocol HousesNetworkService {
    func getHouses(pageSize: Int, skip: Int) -> AnyPublisher<[HouseResponseModel], NetworkError>
}

final class HousesNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == HouseEndPoint {
    let housesProvider: NetworkProvider
    
    init(housesProvider: NetworkProvider) {
        self.housesProvider = housesProvider
    }
}

extension HousesNetworkServiceImpl: HousesNetworkService {
    func getHouses(pageSize: Int, skip: Int) -> AnyPublisher<[HouseResponseModel], NetworkError> {
        return housesProvider.execute(endpoint: .getHouses(pageSize: pageSize, skip: skip))
    }
}
