//
//  Errors.swift
//  CollectionComposition
//
//  Created by User on 13.02.2023.
//

import Foundation
enum RequestBuilderError: Error, LocalizedError, Equatable {
    case unableToCreateComponents(code: Int, error: String)
    case unableToBuildUrl
    case unableToBuildRequest
    
    var errorDescription: String? {
        switch self {
        case let .unableToCreateComponents(code: code, error: error):
            return "Unable to create URL components"
        case .unableToBuildUrl:
            return "Unable to get URL from components"
        case .unableToBuildRequest:
            return "Unable to build URL request"
        }
    }
}

enum NetworkError: Error, LocalizedError, Equatable {
    case cannotBuildRequest(reason: RequestBuilderError)
    case badURL(_ error: URLError)
    case apiError(code: Int, error: String)
    case invalidJSON(_ error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError(code: Int, error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Bad URL"
        case let .apiError(code: code, error: error):
            return "API error"
        case .invalidJSON:
            return "Invalid JSON"
        case let .unauthorized(code: code, error: error):
            return "Unauthorized"
        case let .badRequest(code: code, error: error):
            return "Bad URL request"
        case let .serverError(code: code, error: error):
            return "Server error"
        case .noResponse:
            return "No response"
        case .unableToParseData:
            return "Unable to parse Data"
        case .unknown:
            return "Unknown error"
        case .cannotBuildRequest(reason: let reason):
            return "Can't build request"
        }
    }
}
