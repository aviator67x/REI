//
//  AuthService.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 20.11.2021.
//

import Combine
import Foundation

enum CustomError: Error {
    case authError
}

protocol AuthNetworkService {
    func signIn(_ requestModel: SignInRequest) -> AnyPublisher<SignInResponse, NetworkError>
    func signUp(_ requestModel: SignUpRequest) -> AnyPublisher<SignUpResponse, NetworkError>
    func restorePassword(_ requestModel: RestoreRequest) -> AnyPublisher<Void, NetworkError>
}

final class AuthNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == AuthEndPoint {
    let authProvider: NetworkProvider

    init(authProvider: NetworkProvider) {
        self.authProvider = authProvider
    }
}

extension AuthNetworkServiceImpl: AuthNetworkService {

    func signIn(_ requestModel: SignInRequest) -> AnyPublisher<SignInResponse, NetworkError> {
        return authProvider.execute(endpoint: .login(model: requestModel))
    }

    func signUp(_ requestModel: SignUpRequest) -> AnyPublisher<SignUpResponse, NetworkError> {
        return authProvider.execute(endpoint: .signUp(model: requestModel))
    }
    
    func restorePassword(_ requestModel: RestoreRequest) -> AnyPublisher<Void, NetworkError> {
        return authProvider.execute(endpoint: .restorePassword(model: requestModel))
    }
    
}
