//
//  UserEndPoint.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation

enum UserEndPoint: Endpoint {
    case deleteUser(id: String)
    case logOut

    var path: String? {
        switch self {
        case .deleteUser:
            return "/data/Person/"
        case .logOut:
            return "/users/logout"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .deleteUser:
            return .delete
        case .logOut:
            return .get
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case let .deleteUser(id: id):
            return ["user-token": id]
        case .logOut:
            return [:]
        }
    }

    var body: RequestBody? {
        switch self {
        case .deleteUser, .logOut:
            return nil
        }
    }
}
