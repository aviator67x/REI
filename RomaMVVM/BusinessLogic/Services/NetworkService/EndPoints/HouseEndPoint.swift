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
    case update(house: UpdateHouseFavouriteParameterRequestModel, houseId: String)

    var queries: HTTPQueries {
        switch self {
        case let .getHouses(pageSize, skip):
            return buildQuery(pageSize: pageSize, skip: skip) ?? [:]
        case let .filter(searchParams):
            return buildQuery(searchParams: searchParams) ?? [:]
        case .update:
            return [:]
        }
    }

    var path: String? {
        switch self {
        case .getHouses, .filter:
            return "/data/Houses"
        case .update(house: _, let houseId):
           return "/data/Houses/\(houseId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getHouses, .filter:
            return .get
        case .update:
            return .put
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .getHouses, .filter, .update:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body: RequestBody? {
        switch self {
        case .getHouses, .filter:
            return nil
        case .update(house: let house, _):
            return .encodable(house)
        }
    }
    
    func buildQuery(pageSize: Int, skip: Int) -> [String: String]? {
        return [
            "pageSize":"\(pageSize)",
            "offset":"\(skip)"]
    }
}
