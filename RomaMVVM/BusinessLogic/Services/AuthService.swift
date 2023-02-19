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
    func signIn(email: String, password: String) -> AnyPublisher<SignInResponse, NetworkError>
    func signUp(email: String, name: String, password: String) -> AnyPublisher<SignUpResponse, NetworkError>
}

class AuthServiceImpl: AuthService {
    let networkRequestable = NetworkRequestable()
    
    func signIn(email: String, password: String) -> AnyPublisher<SignInResponse, NetworkError> {
        let loginRequestModel = SignInRequest(login: email, password: password)
        let authEndPoint = AuthEndPoint.login(model: loginRequestModel)
        guard let networkRequest = authEndPoint.buildRequest()
        else { fatalError("Can't build URLRequest for Login flow") }

        return networkRequestable.request(networkRequest)
    }

    func signUp(email: String, name: String, password: String) -> AnyPublisher<SignUpResponse, NetworkError> {
        let signUpRequestModel = SignUpRequest(name: name, email: email, password: password)
        let authEndPoint = AuthEndPoint.signUp(model: signUpRequestModel)
        guard let request = authEndPoint.buildRequest() else {
            fatalError("Can't build URLRequest for SignUp flow")
        }

        return networkRequestable.request(request)
    }
}
