//
//  AuthEndPoint.swift
//  RomaMVVM
//
//  Created by User on 20.02.2023.
//

import Foundation

enum AuthEndPoint: Endpoint {
    case login(model: SignInRequest)
    case signUp(model: SignUpRequest)
    case recoverPassword

    var path: String? {
        switch self {
        case .login:
            return "/users/login"
        case .signUp:
            return "/data/Users"
        case .recoverPassword:
            return "/users/restorepassword/:userIdentity"
        }
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

    var body: RequestBody? {
        switch self {
        case .login(model: let model):
            return .encodable(model)
        case .signUp(model: let model):
            return .encodable(model)
        case .recoverPassword:
           return nil
        }
    }
}
