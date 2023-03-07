//
//  PropertyService.swift
//  RomaMVVM
//
//  Created by User on 07.03.2023.
//

import Foundation
import Combine

protocol PropertyNetworkService {
    func filter(queries: [String:String]) -> AnyPublisher<[PropertyResponse], NetworkError>
}

final class PropertyNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == PropertyEndPoint {
    let propertyProvider: NetworkProvider
    
    init(propertyProvider: NetworkProvider) {
        self.propertyProvider = propertyProvider
    }
}

extension PropertyNetworkServiceImpl: PropertyNetworkService {
    func filter(queries: [String:String]) -> AnyPublisher<[PropertyResponse], NetworkError> {
        return propertyProvider.execute(endpoint: .filter(queries: queries))
    }
}
