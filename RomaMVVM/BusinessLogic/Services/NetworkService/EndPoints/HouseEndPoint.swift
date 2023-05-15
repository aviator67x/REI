//
//  HouseEndPoint.swift
//  RomaMVVM
//
//  Created by User on 06.04.2023.
//

import Foundation

enum HouseEndPoint: Endpoint {
    case getHouses(pageSize: Int, skip: Int)
    case filter(with: [SearchParam])

    var queries: HTTPQueries {
        switch self {
        case let .getHouses(pageSize, skip):
            return buildQuery(pageSize: pageSize, skip: skip) ?? [:]
        case let .filter(searchParams):
            return buildQuery(searchParams: searchParams) ?? [:]
        }
    }

    var path: String? {
        switch self {
        case .getHouses, .filter:
            return "/data/Houses"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHouses, .filter:
            return .get
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .getHouses, .filter:
            return ["Content-Type": "application/json"]
        }
    }
    
        var body: RequestBody? {
            switch self {
            case .getHouses, .filter:
                return nil
            }
        }
    func buildQuery(pageSize: Int, skip: Int) -> [String: String]? {
        return [
            "pageSize":"\(pageSize)",
            "offset":"\(skip)"]
    }
}
