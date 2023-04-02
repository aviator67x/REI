//
//  AppContainer.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import CombineNetworking
import Foundation

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
    var authNetworkService: AuthNetworkService { get }
    var userService: UserService { get }
    var userNetworkService: UserNetworkService { get }
    var appSettingsService: AppSettingsService { get }
    var tokenStorageService: TokenStorageService { get }
    var keychainService: KeychainService { get }
    var propertyNetworkService: PropertyNetworkService { get }
}

final class AppContainerImpl: AppContainer {
    let appConfiguration: AppConfiguration
    let authNetworkService: AuthNetworkService
    let userNetworkService: UserNetworkService
    let userService: UserService
    let appSettingsService: AppSettingsService
    let tokenStorageService: TokenStorageService
    var keychainService: KeychainService
    let propertyNetworkService: PropertyNetworkService

    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration

        let networkManagerImpl = NetworkManagerImpl(session: URLSession.shared)

        let networkServiceProvider = NetworkServiceProviderImpl<AuthEndPoint>(
            baseURLStorage: appConfiguration,
            networkManager: networkManagerImpl,
            encoder: JSONEncoder(),
            decoder: JSONDecoder()
        )
        let authService = AuthNetworkServiceImpl(authProvider: networkServiceProvider)
        self.authNetworkService = authService

        let userNetworkServiceProvider = NetworkServiceProviderImpl<UserEndPoint>(
            baseURLStorage: appConfiguration,
            networkManager: networkManagerImpl,
            encoder: JSONEncoder(),
            decoder: JSONDecoder()
        )
        let userNetworkService = UserNetworkServiceImpl(userProvider: userNetworkServiceProvider)
        self.userNetworkService = userNetworkService

        let propertyNetworkServiceProvider =
            NetworkServiceProviderImpl<PropertyEndPoint>(
                baseURLStorage: appConfiguration,
                networkManager: networkManagerImpl,
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            )
        let propertyNetworkService = PropertyNetworkServiceImpl(propertyProvider: propertyNetworkServiceProvider)
        self.propertyNetworkService = propertyNetworkService

        self.tokenStorageService = TokenStorageServiceImpl(configuration: appConfiguration)
        self.keychainService = KeychainService()
        let userService = UserServiceImpl(
            tokenStorageService: tokenStorageService,
            userNetworkService: userNetworkService,
            keychainService: keychainService
        )
        self.userService = userService

        let appSettingsService = AppSettingsServiceImpl()
        self.appSettingsService = appSettingsService

        let authPlugin = AuthPlugin(token: appConfiguration.environment.apiKey)
    }
}
