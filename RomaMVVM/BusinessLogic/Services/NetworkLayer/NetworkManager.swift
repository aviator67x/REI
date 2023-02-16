//
//  NetworkManager.swift
//  CollectionComposition
//
//  Created by User on 13.02.2023.
//

import Combine
import Foundation

struct LoginRequestModel: Encodable {
    var login: String
    var password: String
}

struct LoginResponseModel: Decodable {
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

struct SignUpRequestModel: Encodable {
    var name, email, password: String
}

struct SignUpResponeModel: Decodable {
    let userId: String

    enum CodingKeys: String, CodingKey {
        case userId = "ownerId"
    }
}

enum AuthEndPoint: EndPoint {
    
    case login(model: LoginRequestModel)
    case signUp(model: SignUpRequestModel)
    case recoverPassword

    var baseURL: String {
        "api.backendless.com"
    }

    var path: String {
        switch self {
        case .login:
            return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/users/login"
        case .signUp:
            return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/data/Users"
        case .recoverPassword:
            return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/users/restorepassword/:userIdentity"
        }
    }

    var query: [String:String]? {
        nil
    }

    var method: HTTPMethod {
        switch self {
        case .login, .signUp:
            return .post
        case .recoverPassword:
            return .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .login:
            return ["Content-Type": "application/json"]
        case .signUp:
            return ["Content-Type": "application/json"]
        case .recoverPassword:
            return [:]
        }
    }

    var body: Data? {
        switch self {
        case let .login(model: model):
            let data = try? JSONEncoder().encode(model)
            
            return data
        case let .signUp(model: model):
            let data = try? JSONEncoder().encode(model)

            return data
        case .recoverPassword:
            return nil
        }
    }
}

class NetworkService {
    let networkRequestable = NetworkRequestable()
    private var networkRequest: EndPoint?

    func login(email: String, password: String) -> AnyPublisher<LoginResponseModel, NetworkError> {
        let loginRequestModel = LoginRequestModel(login: email, password: password)
        let authEndPoint = AuthEndPoint.login(model: loginRequestModel)
        guard let networkRequest = authEndPoint.buildRequest()
        else { fatalError("Can't build URLRequest for Login flow") }

        return networkRequestable.request(networkRequest)
    }

    func signUp(name: String, email: String, password: String) -> AnyPublisher<SignUpResponeModel, NetworkError> {
        let signUpRequestModel = SignUpRequestModel(name: name, email: email, password: password)
        let authEndPoint = AuthEndPoint.signUp(model: signUpRequestModel)
        guard let request = authEndPoint.buildRequest() else { fatalError("Can't build URLRequest for SignUp flow") }

        return networkRequestable.request(request)
    }
}
