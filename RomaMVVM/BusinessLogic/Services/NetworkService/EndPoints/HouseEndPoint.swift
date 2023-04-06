//
//  HouseEndPoint.swift
//  RomaMVVM
//
//  Created by User on 06.04.2023.
//

import Foundation

enum HouseEndPoint: Endpoint {
    case getHouses

    var path: String? {
        switch self {
        case .getHouses:
            return "/data/Houses"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getHouses:
            return .get
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .getHouses:
            return ["Content-Type": "application/json"]
        }
    }

    var body: RequestBody? {
        switch self {
        case .getHouses:
            return nil
        }
    }
}
