//
//  HouseEndPoint.swift
//  RomaMVVM
//
//  Created by User on 06.04.2023.
//

import Foundation

enum HouseEndPoint: Endpoint {
    case getHouses(pageSize: Int, skip: Int)
    
    var queries: HTTPQueries {
        switch self {
        case .getHouses(let pageSize, let skip):
            return buildQuery(pageSize: pageSize, skip: skip) ?? [:]
        }
    }

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
