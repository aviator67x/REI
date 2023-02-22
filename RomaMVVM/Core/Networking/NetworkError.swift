//
//  Errors.swift
//  CollectionComposition
//
//  Created by User on 13.02.2023.
//

import Foundation
enum RequestBuilderError: Error, LocalizedError, Equatable {
    case unableToCreateComponents
    case unableToBuildUrl
    case unableToBuildRequest
    case unableToEncode

    var errorDescription: String? {
        switch self {
        case .unableToCreateComponents:
            return "Unable to create URL components"
        case .unableToBuildUrl:
            return "Unable to get URL from components"
        case .unableToBuildRequest:
            return "Unable to build URL request"
        case .unableToEncode:
            return "Unable to encode"
        }
    }
}

enum NetworkError: Error, LocalizedError, Equatable {
    case cannotBuildRequest(reason: RequestBuilderError)
    case badURL(_ error: URLError)
    case apiError
    case invalidJSON
    case unauthorized
    case badRequest
    case serverError
    case noResponse
    case unableToParseData
    case unknown

    var errorDescription: String? {
        switch self {
        case let .cannotBuildRequest(reason: reason):
            return "Can't build request because of \(reason)"
        case .badURL:
            return "Bad URL"
        case .apiError:
            return "API error"
        case .invalidJSON:
            return "Invalid JSON"
        case .unauthorized:
            return "Unauthorized"
        case .badRequest:
            return "Bad URL request"
        case .serverError:
            return "Server error"
        case .noResponse:
            return "No response"
        case .unableToParseData:
            return "Unable to parse Data"
        case .unknown:
            return "Unknown error"
        }
    }
}
