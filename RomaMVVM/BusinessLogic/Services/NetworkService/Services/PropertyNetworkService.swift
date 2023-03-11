//
//  PropertyService.swift
//  RomaMVVM
//
//  Created by User on 07.03.2023.
//

import Foundation
import Combine

protocol PropertyNetworkService {
    func search(with parameters: [SearchParam]) -> AnyPublisher<[PropertyResponse], NetworkError>
}

final class PropertyNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == PropertyEndPoint {
    let propertyProvider: NetworkProvider
    
    init(propertyProvider: NetworkProvider) {
        self.propertyProvider = propertyProvider
    }
}

extension PropertyNetworkServiceImpl: PropertyNetworkService {
    func search(with parameters: [SearchParam]) -> AnyPublisher<[PropertyResponse], NetworkError> {
        return propertyProvider.execute(endpoint: .filter(with: parameters))
    }
}
