//
//  AppEnvironment.swift
//  REI
//
//  Created by user on 16.12.2021.
//

import Foundation

enum AppEnvironment: String {
    case dev
    case stg
    case prod
    case mock

    var baseURL: URL {
        switch self {
        case .dev: return URL(string: "https://api.backendless.com")!
        case .stg: return URL(string: "https://api.backendless.com")!
        case .prod: return URL(string: "https://api.backendless.com")!
        case .mock:
            guard let url = Bundle.main.url(forResource: "JsonHouses", withExtension: "json") else {
                fatalError("Can not creare url to file named JsonHouses")
            }
            return url
        }
    }
    
    var apiKey: String {
        switch self {
        case .dev: return "/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B"
        case .stg: return "/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B"
        case .prod: return "04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B"
        case .mock: return ""
        }
    }

    var appId: String {
        switch self {
        case .dev: return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000"
        case .stg: return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000"
        case .prod: return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000"
        case .mock: return ""
        }
    }
}
