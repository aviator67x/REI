//
//  HouseEndPoint.swift
//  REI
//
//  Created by User on 06.04.2023.
//

import Foundation

enum HouseEndPoint: Endpoint {
    case getHouses(pageSize: Int, skip: Int, searchParameters: [SearchParam]?, sortParameters: [String]?)
    case getHousesCountFor(filters: [SearchParam])
    case filter(with: [SearchParam])
    case getHousesIn(poligon: String)
    case housesCount
    case saveImage([MultipartItem])
    case saveAd(AdCreatingRequestModel)
    case getUserAds(ownerId: String)
    case deleteAd(objectId: String)

    var queries: HTTPQueries {
        switch self {
        case let .getHouses(
            pageSize,
            skip,
            searchParameters,
            sortParameters
        ):
            return buildQuery(
                pageSize: pageSize,
                skip: skip,
                searchParameters: searchParameters,
                sortParameters: sortParameters
            ) ?? []

        case let .filter(searchParams):
            if let searchParameters = buildQuery(searchParams: searchParams),
               let searchParametersString = searchParameters["where"] {
                return [QueryParameters.whereParam(searchParametersString)]
            }
          

        case .saveImage, .saveAd, .housesCount:
            return []

        case let .getUserAds(ownerId: ownerId):
            let searchParams = [SearchParam(key: .ownerId, value: .equalToString(parameter: ownerId))]
            if let searchParameters = buildQuery(searchParams: searchParams),
               let searchParametersString = searchParameters["where"] {
                return [QueryParameters.whereParam(searchParametersString)]
            }
            
        case .deleteAd:
            return []

        case let .getHousesIn(poligon):
            let searchParams = [SearchParam(key: .location, value: .inside(poligon: poligon))]
            if let searchParameters = buildQuery(searchParams: searchParams),
               let searchParametersString = searchParameters["where"] {
                return [QueryParameters.whereParam(searchParametersString)]
            }
            
        case let .getHousesCountFor(filters):
            if let searchParameters = buildQuery(searchParams: filters),
               let searchParametersString = searchParameters["where"] {
                return [QueryParameters.whereParam(searchParametersString)]
            }
        }
        return []
    }

    var path: String? {
        switch self {
        case .getHouses, .filter, .saveAd, .getUserAds, .getHousesIn:
            return "/data/Houses"
        case .saveImage:
            return "/files/Houses"
        case .housesCount, .getHousesCountFor:
            return "/data/Houses/count"
        case let .deleteAd(objectId: objectId):
            return "data/Houses/\(objectId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getHouses, .filter, .housesCount, .getUserAds, .getHousesIn, .getHousesCountFor:
            return .get
        case .saveImage, .saveAd:
            return .post
        case .deleteAd:
            return .delete
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .getHouses, .filter, .saveAd, .housesCount, .getUserAds, .deleteAd, .getHousesIn, .getHousesCountFor:
            return ["Content-Type": "application/json"]
        case .saveImage:
            return [:]
        }
    }

    var body: RequestBody? {
        switch self {
        case .getHouses, .filter, .housesCount, .getUserAds, .deleteAd, .getHousesIn, .getHousesCountFor:
            return nil
        case let .saveImage(image):
            return .multipartBody(image)
        case let .saveAd(adModel):
            return .encodable(adModel)
        }
    }

    func buildQuery(
        pageSize: Int,
        skip: Int,
        searchParameters: [SearchParam]?,
        sortParameters: [String]?
    ) -> [QueryParameters]? {
        var searchParamString: String?
        if let serchParameters = searchParameters {
            let search = Search.searchProperty(serchParameters)
            searchParamString = search.query?["where"]
        }

        if let searchParametersString = searchParamString {
            if let parameters = sortParameters {
                let paramString = parameters.joined(separator: ", ")
                return [
                    QueryParameters.whereParam(searchParametersString),
                    QueryParameters.sortParam(paramString),
                    QueryParameters.pageParam(pageSize),
                    QueryParameters.offsetParam(skip)
                ]
            } else {
                return [
                    QueryParameters.whereParam(searchParametersString),
                    QueryParameters.pageParam(pageSize),
                    QueryParameters.offsetParam(skip)
                ]
            }
        } else if let parameters = sortParameters {
            let paramString = parameters.joined(separator: ", ")
            return [
                QueryParameters.sortParam(paramString),
                QueryParameters.pageParam(pageSize),
                QueryParameters.offsetParam(skip)
            ]
        } else {
            return [
                QueryParameters.pageParam(pageSize),
                QueryParameters.offsetParam(skip)
            ]
        }
    }
}
