//
//  PropertyService.swift
//  RomaMVVM
//
//  Created by User on 07.03.2023.
//

import Foundation
import CombineNetworking

enum PropertyEndPoint: Endpoint {
    case filter(queries: [String:String])

    var queries: HTTPQueries {
        switch self {
        case var .filter(queries):
//            buildFilterQuery(queries: &queries)
//            return queries
            return ["where":"propertyType = 'Flat' and area >= 50 and area <= 60"]
        }
    }
    
    var path: String? {
        switch self {
        case .filter:
            return "/data/Property"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .filter:
            return .get
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .filter:
            return ["Content-Type": "application/json"]
        }
    }

    var body: RequestBody? {
        switch self {
        case .filter:
            return nil
        }
    }
    
    func buildFilterQuery(queries: inout HTTPQueries) {
        var queryString = ""
        var counter = 1
        queries.forEach { query in
            if counter < queries.count {
                counter += 1
                queryString += "\(query.key) = \(query.value) and "
            } else {
                queryString += "\(query.key) = \(query.value)"
            }
            
        }
        queries = [:]
        queries["where"] = queryString
    }
}

