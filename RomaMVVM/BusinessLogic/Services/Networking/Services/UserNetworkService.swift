//
//  UserService.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation
import Combine

protocol UserNetworkService {
    func deleteUser(with id: String) -> AnyPublisher<Void, NetworkError>
}

final class UserNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == UserEndPoint {
    let authProvder: NetworkProvider
    
    init(authProvder: NetworkProvider) {
        self.authProvder = authProvder
    }
}
extension UserNetworkServiceImpl: UserNetworkService {
    func deleteUser(with id: String) -> AnyPublisher<Void, NetworkError> {
        return authProvder.execute(endpoint: .deleteUser(id: id))
    }
}
