//
//  AppContainer.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Foundation
import CombineNetworking

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
    var authService: AuthNetworkService { get }
    var userService: UserService { get }
    var userNetworkService: UserNetworkService { get }
    var appSettingsService: AppSettingsService { get }
    var dogService: DogService { get }
}

final class AppContainerImpl: AppContainer {
    let appConfiguration: AppConfiguration
    let authService: AuthNetworkService
    let userService: UserService
    let userNetworkService: UserNetworkService
    let appSettingsService: AppSettingsService
    let dogService: DogService

    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration
        
        let networkManagerImpl = NetworkManagerImpl(session: URLSession.shared)
        
        let networkServiceProvider = NetworkServiceProviderImpl<AuthEndPoint>(baseURLStorage: appConfiguration,
                                                                              networkManager: networkManagerImpl,
                                                                              encoder: JSONEncoder(),
                                                                              decoder: JSONDecoder())
        let authService = AuthNetworkServiceImpl(authProvider: networkServiceProvider)
        self.authService = authService

        let userService = UserServiceImpl(configuration: appConfiguration)
        self.userService = userService
        
        let userNetworkServiceProvider = NetworkServiceProviderImpl<UserEndPoint>(baseURLStorage: appConfiguration,
                                                                                  networkManager: networkManagerImpl,
                                                                                  encoder: JSONEncoder(),
                                                                                  decoder: JSONDecoder())
        let userNetworkService = UserNetworkServiceImpl(userProvider: userNetworkServiceProvider)
        self.userNetworkService = userNetworkService
        
        let appSettingsService = AppSettingsServiceImpl()
        self.appSettingsService = appSettingsService

        let authPlugin = AuthPlugin(token: appConfiguration.environment.apiKey)
        
        let provider = CNProvider(baseURL: appConfiguration.environment.baseURL,
                                  requestBuilder: DogAPIRequestBuilder.self,
                                  plugins: [authPlugin])        
        self.dogService = DogServiceImpl(provider)
    }
}
