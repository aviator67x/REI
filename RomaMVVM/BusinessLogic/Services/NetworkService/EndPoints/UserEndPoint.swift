//
//  UserEndPoint.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation

enum UserEndPoint: Endpoint {
    case deleteUser(id: String)
    case logOut(token: String)
    case addAvatar(image: [MultipartItem])

    var path: String? {
        switch self {
        case .deleteUser:
            return "/data/Person/"
        case .logOut:
            return "/users/logout"
        case .addAvatar:
            return "/files/images"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .deleteUser:
            return .delete
        case .logOut:
            return .get
        case .addAvatar:
            return .post
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case let .deleteUser(id: id):
            return ["user-token": id]
        case .logOut(let token):
            return ["Content-Type": "application/json",
                    "user-token": token]
        case .addAvatar:
            return [:]
        }
    }

    var body: RequestBody? {
        switch self {
        case .deleteUser, .logOut:
            return nil
        case .addAvatar(image: let image):
            
            return .multipartBody(image)
        }
    }
}
