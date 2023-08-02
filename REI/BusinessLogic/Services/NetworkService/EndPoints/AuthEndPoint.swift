//
//  AuthEndPoint.swift
//  REI
//
//  Created by User on 20.02.2023.
//

import Foundation

enum AuthEndPoint: Endpoint {
    case login(model: SignInRequest)
    case signUp(model: SignUpRequest)
    case restorePassword(model: RestoreRequest)

    var path: String? {
        switch self {
        case .login:
            return "/users/login"
        case .signUp:
            return "/data/Users"
        case .restorePassword(let model):
            return "/users/restorepassword/\(model.email)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .signUp:
            return .post
        case .restorePassword:
            return .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .login:
            return ["Content-Type": "application/json"]
        case .signUp:
            return ["Content-Type": "application/json"]
        case .restorePassword:
            return [:]
        }
    }

    var body: RequestBody? {
        switch self {
        case let .login(model: model):
            return .encodable(model)
        case let .signUp(model: model):
            return .encodable(model)
        case .restorePassword:
            return nil
        }
    }

    var queries: HTTPQueries {
        switch self {
        case .login, .signUp,.restorePassword:
           return [:]
        }
    }
}
