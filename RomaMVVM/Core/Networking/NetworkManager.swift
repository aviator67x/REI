//
//  NetworkManager.swift
//  RomaMVVM
//
//  Created by user on 20.02.2023.
//

import Combine
import Foundation

protocol NetworkManager {
    func execute(request: URLRequest) -> AnyPublisher<Data, Error>
}

class NetworkManagerImpl: NetworkManager {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func execute(request: URLRequest) -> AnyPublisher<Data, Error> {
        NetworkLogger.log(request: request)
        return session.dataTaskPublisher(for: request)
            .tryMap { [unowned self] data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.noResponse
                }
                print("[\(response.statusCode)] '\(request.url!)'")

                if !(200 ... 299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                
                return data
            }
//            .mapError { error in
//                NetworkError.badURL(error)
//            }
//            .flatMap { output -> AnyPublisher<Data, NetworkError> in
//
//                guard let httpResponse = output.response as? HTTPURLResponse else {
//                    return Fail(error: NetworkError.noResponse)
//                        .eraseToAnyPublisher()
//                }
//                NetworkLogger.log(response: httpResponse)

//                switch httpResponse.statusCode {
//                case 200 ... 399:
//                    return Just(output.data)
//                        .setFailureType(to: NetworkError.self)
//                        .eraseToAnyPublisher()
//                case 400: return Fail(error: NetworkError.badRequest)
//                    .eraseToAnyPublisher()
//                case 401: return Fail(error: NetworkError.unauthorized)
//                    .eraseToAnyPublisher()
//                case 403: return Fail(error: NetworkError.forbidden)
//                    .eraseToAnyPublisher()
//                case 404: return Fail(error: NetworkError.notFound)
//                    .eraseToAnyPublisher()
//                case 402, 405 ... 499:
//                    return Fail(error: NetworkError.badRequest)
//                        .eraseToAnyPublisher()
//                case 500 ... 599:
//                    return Fail(error: NetworkError.serverError)
//                        .eraseToAnyPublisher()
//                default:
//                    return Fail(error: NetworkError.unknown)
//                        .eraseToAnyPublisher()
//                }
//            }
            .eraseToAnyPublisher()
    }

    private func httpError(_ statusCode: Int) -> Error {
        switch statusCode {
        case 400: return NetworkError.badRequest
        case 401: return NetworkError.unauthorized
        case 403: return NetworkError.forbidden
        case 404: return NetworkError.notFound
        case 402, 405 ... 499: return NetworkError.badRequest
        case 500 ... 599: return NetworkError.serverError
        default: return NetworkError.unknown
        }
    }
}
