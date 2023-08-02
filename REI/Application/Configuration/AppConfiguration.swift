//
//  AppConfiguration.swift
//  REI
//
//  Created by user on 28.11.2021.
//

import Foundation

protocol BaseURLStorage {
    var baseURL: URL { get }
}

protocol AppConfiguration: BaseURLStorage {
    var bundleId: String { get }
    var environment: AppEnvironment { get }
}

final class AppConfigurationImpl: AppConfiguration {
    let bundleId: String
    let environment: AppEnvironment
    private let apiKey: String
    private let appId: String

    init(bundle: Bundle = .main) {
        guard
            let bundleId = bundle.bundleIdentifier,
            let infoDict = bundle.infoDictionary,
            let environmentValue = infoDict[Key.Environment] as? String,
            let apiKey = infoDict[Key.ApiKey] as? String,
            let appId = infoDict[Key.AppId] as? String,
            let environment = AppEnvironment(rawValue: environmentValue)
        else {
            fatalError("config file error")
        }

        self.bundleId = bundleId
        self.environment = environment
        self.apiKey = apiKey
        self.appId = appId

        debugPrint(environment)
        debugPrint(bundleId)
        debugPrint(apiKey)
        debugPrint(appId)
    }

    lazy var baseURL: URL = {
        return environment.baseURL.appendingPathComponent(appId).appendingPathComponent(apiKey)        
    }()

    private enum Key {
        static let Environment = "APP_ENVIRONMENT"
        static let ApiKey = "APP_API_KEY"
        static let AppId = "APP_APP_ID"
    }
}
