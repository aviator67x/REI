//
//  NetworkServiceProvider.swift
//  NetworkingDemo
//
//  Created by Roman Savchenko on 20.02.2023.
//

import Combine
import Foundation

protocol NetworkServiceProvider {
    associatedtype E: Endpoint

    func execute(endpoint: E) -> AnyPublisher<Void, NetworkError>
    func execute<Model: Decodable>(endpoint: E) -> AnyPublisher<Model, NetworkError>
}

class NetworkServiceProviderImpl<E: Endpoint>: NetworkServiceProvider {
    private let baseURLStorage: BaseURLStorage
    private let networkManager: NetworkManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(baseURLStorage: BaseURLStorage, networkManager: NetworkManager, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.baseURLStorage = baseURLStorage
        self.networkManager = networkManager
        self.encoder = encoder
        self.decoder = decoder
    }

    func execute(endpoint: E) -> AnyPublisher<Void, NetworkError> {
        do {
           let request = try endpoint.build(baseURL: baseURLStorage.baseURL, encoder: encoder)
            return networkManager.execute(request: request)
                .map { _ in }
                .eraseToAnyPublisher()
        } catch let error as RequestBuilderError {
            debugPrint(error.localizedDescription)
            return Fail(error: NetworkError.cannotBuildRequest(reason: error))
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.unknown)
                .eraseToAnyPublisher()
        }
      
    }

    func execute<Model: Decodable>(endpoint: E) -> AnyPublisher<Model, NetworkError> {
        do {
            let request = try endpoint.build(baseURL: baseURLStorage.baseURL, encoder: encoder)
            return networkManager.execute(request: request)
//                        .decode(type: decodeType, decoder: decoder)
                .decode(type: Model.self, decoder: decoder)
                        .mapError { _ in
                            NetworkError.unknown
                        }
                        .eraseToAnyPublisher()
        } catch let error as RequestBuilderError {
            debugPrint(error.localizedDescription)
            return Fail(error: NetworkError.cannotBuildRequest(reason: error))
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.unknown)
                .eraseToAnyPublisher()
        }
    }
}
