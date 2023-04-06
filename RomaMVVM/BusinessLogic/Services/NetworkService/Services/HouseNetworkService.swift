//
//  HouseNetworkService.swift
//  RomaMVVM
//
//  Created by User on 06.04.2023.
//

import Foundation
import Combine

protocol HouseNetworkService {
    func getHouses() -> AnyPublisher<HouseResponceModel, NetworkError>
}

//final class HouseNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == UEndPoint 
