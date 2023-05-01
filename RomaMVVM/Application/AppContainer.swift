//
//  AppContainer.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import CombineNetworking
import Foundation
import KeychainAccess

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
    var authNetworkService: AuthNetworkService { get }
    var userService: UserService { get }
    var appSettingsService: AppSettingsService { get }
    var propertyNetworkService: PropertyNetworkService { get }
    var searchRequestModel: SearchRequestModel { get }
    var housesService: HousesService { get }
}

final class AppContainerImpl: AppContainer {
    let appConfiguration: AppConfiguration
    let authNetworkService: AuthNetworkService
    let userService: UserService
    let appSettingsService: AppSettingsService
    let propertyNetworkService: PropertyNetworkService
    let searchRequestModel: SearchRequestModel
    let housesService: HousesService

    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration
        
        let keychainService = Keychain(service: appConfiguration.bundleId)
        let tokenStorageService = TokenStorageServiceImpl(keychain: keychainService)
        let tokenPlugin = TokenPlugin(tokenStorage: tokenStorageService)
        let networkManagerImpl = NetworkManagerImpl(session: URLSession.shared)

        let networkServiceProvider = NetworkServiceProviderImpl<AuthEndPoint>(
            baseURLStorage: appConfiguration,
            networkManager: networkManagerImpl,
            encoder: JSONEncoder(),
            decoder: JSONDecoder(),
            plugins: [tokenPlugin]
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
        let userService = UserServiceImpl(
            tokenStorageService: tokenStorageService,
            userNetworkService: userNetworkService
        )
        self.userService = userService

        let propertyNetworkServiceProvider =
            NetworkServiceProviderImpl<PropertyEndPoint>(
                baseURLStorage: appConfiguration,
                networkManager: networkManagerImpl,
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            )
        let propertyNetworkService = PropertyNetworkServiceImpl(propertyProvider: propertyNetworkServiceProvider)
        self.propertyNetworkService = propertyNetworkService
        
        let housesNetworkServiceProvider =
            NetworkServiceProviderImpl<HouseEndPoint>(
                baseURLStorage: appConfiguration,
                networkManager: networkManagerImpl,
                encoder: JSONEncoder(),
                decoder: JSONDecoder()        
            )        
        let housesNetworkService = HousesNetworkServiceImpl(housesProvider: housesNetworkServiceProvider)
        self.housesService = HousesServiceImpl(housesNetworkService: housesNetworkService)

        let appSettingsService = AppSettingsServiceImpl()
        self.appSettingsService = appSettingsService

        var searchRequestModel: SearchRequestModel { SearchRequestModel() }
        self.searchRequestModel = searchRequestModel
    }
}
