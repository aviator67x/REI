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

    var queries: HTTPQueries {
        switch self {
        case let .getHouses(pageSize, skip):
            return buildQuery(pageSize: pageSize, skip: skip) ?? [:]
        case let .filter(searchParams):
            return buildQuery(searchParams: searchParams) ?? [:]
        case .saveImage, .saveAd:
            return [:]
        }
    }

    var path: String? {
        switch self {
        case .getHouses, .filter, .saveAd:
            return "/data/Houses"
        case .saveImage:
            return "/files/Houses"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHouses, .filter:
            return .get
        case .saveImage, .saveAd:
            return .post
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .getHouses, .filter, .saveAd:
            return ["Content-Type": "application/json"]
        case .saveImage:
            return [:]
//            return ["Content-Type": "multipart/form-data"]
        }
    }
    
        var body: RequestBody? {
            switch self {
            case .getHouses, .filter:
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
