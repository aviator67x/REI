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
    case update(user: UpdateUserRequestModel)
    case saveToFavourities(houses: [String], userId: String)
    case getFavouriteHouses(userId: String)
    case syncronize
    
    var queries: HTTPQueries {
        switch self {
        case .deleteUser, .logOut, .addAvatar, .update, .saveToFavourities:
            return [:]
        case .getFavouriteHouses:
            return ["loadRelations":"favouriteHouses"]
        case .syncronize:
            return [:]
        }
    }

    var path: String? {
        switch self {
        case .deleteUser:
            return "/data/Person/"
        case .logOut:
            return "/users/logout"
        case .addAvatar:
            return "/files/images"
        case .update(let user):
            return "/users/\(user.id)"
        case .saveToFavourities(_, let userId):
            return "/data/users/\(userId)/favouriteHouses:Houses:n"
        case .getFavouriteHouses(let userId):
            return "/data/users/\(userId)"
        case .syncronize:
            return "/data/Users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .deleteUser:
            return .delete
        case .logOut, .getFavouriteHouses, .syncronize:
            return .get
        case .addAvatar:
            return .post
        case .update:
            return .put
        case .saveToFavourities:
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
        case .update:
            return ["Content-Type": "text/plain"]
        case .saveToFavourities, .getFavouriteHouses, .syncronize:
            return ["Content-Type": "application/json"]
        }
    }

    var body: RequestBody? {
        switch self {
        case .deleteUser, .logOut, .getFavouriteHouses, .syncronize:
            return nil
        case .addAvatar(image: let image):
            return .multipartBody(image)
        case .update(let user):
            return .encodable(user)
        case .saveToFavourities(houses: let houses, _):
            return .encodable(houses)
        }
    }
}
