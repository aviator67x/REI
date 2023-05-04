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
    var searchModel: SearchModel { get }
    var housesService: HousesService { get }
}

final class AppContainerImpl: AppContainer {
    let appConfiguration: AppConfiguration
    let authNetworkService: AuthNetworkService
    let userService: UserService
    let appSettingsService: AppSettingsService
    let searchModel: SearchModel
    let housesService: HousesService

    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration
        
        let appSettingsService = AppSettingsServiceImpl()
        self.appSettingsService = appSettingsService
        
        let keychainService = Keychain(service: appConfiguration.bundleId)
        let tokenStorageService = TokenStorageServiceImpl(keychain: keychainService)
        let tokenPlugin = TokenPlugin(tokenStorage: tokenStorageService)
        let networkManagerImpl = NetworkManagerImpl(session: URLSession.shared)
        
        let authNetworkServiceProvider = NetworkServiceProviderImpl<AuthEndPoint>(
            baseURLStorage: appConfiguration,
            networkManager: networkManagerImpl,
            encoder: JSONEncoder(),
            decoder: JSONDecoder(),
            plugins: [tokenPlugin]
        )
        let authService = AuthNetworkServiceImpl(authProvider: authNetworkServiceProvider)
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
        
        let housesNetworkServiceProvider =
            NetworkServiceProviderImpl<HouseEndPoint>(
                baseURLStorage: appConfiguration,
                networkManager: networkManagerImpl,
                encoder: JSONEncoder(),
                decoder: JSONDecoder()        
            )        
        let housesNetworkService = HousesNetworkServiceImpl(housesProvider: housesNetworkServiceProvider)
        self.housesService = HousesServiceImpl(housesNetworkService: housesNetworkService)

        self.searchModel = SearchModel(housesService: housesService)
    }
}
