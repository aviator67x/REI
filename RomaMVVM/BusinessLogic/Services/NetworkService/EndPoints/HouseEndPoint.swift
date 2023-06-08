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
    case saveImage([MultipartItem])
    case saveAd(AdCreatingRequestModel)
    case housesCount
    case getUserAds(ownerId: String)
    case deleteAd(objectId: String)

    var queries: HTTPQueries {
        switch self {
        case let .getHouses(pageSize, skip):
            return buildQuery(pageSize: pageSize, skip: skip) ?? [:]
        case let .filter(searchParams):
            return buildQuery(searchParams: searchParams) ?? [:]
        case .saveImage, .saveAd, .housesCount:
            return [:]
        case .getUserAds(ownerId: let ownerId):
            let searchParams = [SearchParam(key: .ownerId, value: .equalToString(parameter: ownerId))]
            return buildQuery(searchParams: searchParams) ?? [:]
        case .deleteAd(objectId: let objectId):
            return [:]
        }
    }

    var path: String? {
        switch self {
        case .getHouses, .filter, .saveAd, .getUserAds:
            return "/data/Houses"
        case .saveImage:
            return "/files/Houses"
        case .housesCount:
            return "/data/Houses/count"
        case .deleteAd(objectId: let objectId):
            return  "data/Houses/\(objectId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHouses, .filter, .housesCount, .getUserAds:
            return .get
        case .saveImage, .saveAd:
            return .post
        case .deleteAd:
            return .delete
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .getHouses, .filter, .saveAd, .housesCount, .getUserAds, .deleteAd:
            return ["Content-Type": "application/json"]
        case .saveImage:
            return [:]
        }
    }
    
        var body: RequestBody? {
            switch self {
            case .getHouses, .filter, .housesCount, .getUserAds, .deleteAd:
                return nil
            case .saveImage(let image):
                return .multipartBody(image)
            case .saveAd(let adModel):
                return .encodable(adModel)
            }
        }
    func buildQuery(pageSize: Int, skip: Int) -> [String: String]? {
        return [
            "pageSize":"\(pageSize)",
            "offset":"\(skip)"]
    }
}
