//
//  HouseEndPoint.swift
//  REI
//
//  Created by User on 06.04.2023.
//

import Foundation

enum HouseEndPoint: Endpoint {
    case getHouses(pageSize: Int, skip: Int)
    case filter(with: [SearchParam])
    case saveImage([MultipartItem])
    case saveAd(AdCreatingRequestModel)
    case housesCount
    case getUserAds(ownerId: String)
    case deleteAd(objectId: String)
    case getHousesIn(poligon: String)
    case housesSorted(by: [String])

    var queries: HTTPQueries {
        switch self {
        case let .getHouses(pageSize, skip):
            return buildQuery(pageSize: pageSize, skip: skip) ?? [:]
        case let .filter(searchParams):
            return buildQuery(searchParams: searchParams) ?? [:]
        case .saveImage, .saveAd, .housesCount:
            return [:]
        case let .getUserAds(ownerId: ownerId):
            let searchParams = [SearchParam(key: .ownerId, value: .equalToString(parameter: ownerId))]
            return buildQuery(searchParams: searchParams) ?? [:]
        case .deleteAd:
            return [:]
        case let .getHousesIn(poligon):
            let searchParams = [SearchParam(key: .location, value: .inside(poligon: poligon))]
            return buildQuery(searchParams: searchParams) ?? [:]
        case let .housesSorted(by):
            return buidQuery(parameters: by) ?? [:]
        }
    }

    var path: String? {
        switch self {
        case .getHouses, .filter, .saveAd, .getUserAds, .getHousesIn, .housesSorted:
            return "/data/Houses"
        case .saveImage:
            return "/files/Houses"
        case .housesCount:
            return "/data/Houses/count"
        case let .deleteAd(objectId: objectId):
            return "data/Houses/\(objectId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getHouses, .filter, .housesCount, .getUserAds, .getHousesIn, .housesSorted:
            return .get
        case .saveImage, .saveAd:
            return .post
        case .deleteAd:
            return .delete
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .getHouses, .filter, .saveAd, .housesCount, .getUserAds, .deleteAd, .getHousesIn, .housesSorted:
            return ["Content-Type": "application/json"]
        case .saveImage:
            return [:]
        }
    }

    var body: RequestBody? {
        switch self {
        case .getHouses, .filter, .housesCount, .getUserAds, .deleteAd, .getHousesIn, .housesSorted:
            return nil
        case let .saveImage(image):
            return .multipartBody(image)
        case let .saveAd(adModel):
            return .encodable(adModel)
        }
    }

    func buildQuery(pageSize: Int, skip: Int) -> [String: String]? {
        return [
            "pageSize": "\(pageSize)",
            "offset": "\(skip)",
        ]
    }

    func buidQuery(parameters: [String]) -> [String: String]? {
        let paramString = parameters.joined(separator: ", ")

        return ["sortBy": paramString]
    }
}
