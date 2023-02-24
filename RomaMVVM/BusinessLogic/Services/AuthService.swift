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

struct SignInRequest: Encodable {
    var login: String
    var password: String
}

struct SignInResponse: Decodable {
    let id: String
    let name: String
    let email: String
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case id = "ownerId"
        case name
        case email
        case accessToken = "user-token"
    }
}

struct SignUpRequest: Encodable {
    var name, email, password: String
}

struct SignUpResponse: Decodable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case name, email, id = "ownerId"
    }
}

protocol AuthService {
    func signIn(_ requestModel: SignInRequest) -> AnyPublisher<SignInResponse, NetworkError>
    func signUp(_ requestModel: SignUpRequest) -> AnyPublisher<SignUpResponse, NetworkError>
}

class AuthServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == AuthEndPoint {
    let authProvider: NetworkProvider

    init(authProvider: NetworkProvider) {
        self.authProvider = authProvider
    }
}

extension AuthServiceImpl: AuthService {
    func signIn(_ requestModel: SignInRequest) -> AnyPublisher<SignInResponse, NetworkError> {
        return authProvider.execute(endpoint: .login(model: requestModel))
    }

    func signUp(_ requestModel: SignUpRequest) -> AnyPublisher<SignUpResponse, NetworkError> {
        return authProvider.execute(endpoint: .signUp(model: requestModel))
    }
}
