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
    private let plugins: [Plugin]

    init(baseURLStorage: BaseURLStorage, networkManager: NetworkManager, encoder: JSONEncoder, decoder: JSONDecoder, plugins: [Plugin] = []) {
        self.baseURLStorage = baseURLStorage
        self.networkManager = networkManager
        self.encoder = encoder
        self.decoder = decoder
        self.plugins = plugins
    }

    func execute(endpoint: E) -> AnyPublisher<Void, NetworkError> {
        do {
            let request = try endpoint.build(baseURL: baseURLStorage.baseURL, encoder: encoder, plugins: plugins)
            return networkManager.execute(request: request)
                .map { _ in }
                .mapError { [unowned self] error -> NetworkError in
                    let mappedError = handleError(error)
                    debugPrint(mappedError.errorDescription ?? "")
                    return mappedError
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

    func execute<Model: Decodable>(endpoint: E) -> AnyPublisher<Model, NetworkError> {
        do {
            let request = try endpoint.build(baseURL: baseURLStorage.baseURL, encoder: encoder, plugins: plugins)
            return networkManager.execute(request: request)
                .decode(type: Model.self, decoder: decoder)
                .mapError { [unowned self] error -> NetworkError in
                    let mappedError = handleError(error)
                    debugPrint(mappedError.errorDescription ?? "")
                    return mappedError
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

    private func handleError(_ error: Error) -> NetworkError {
        switch error {
        case let error as Swift.DecodingError:
            return .decodingError(error)
        case let urlError as URLError:
            return .badURL(urlError)
        case let error as NetworkError:
            return error
        default:
            return NetworkError.unknown
        }
    }
}
