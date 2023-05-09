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
//        NetworkLogger.log(request: request)
        print(request.cURL())
        return session.dataTaskPublisher(for: request)
            .tryMap { [unowned self] data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.noResponse
                }
                print("[\(response.statusCode)] '\(request.url!)'")

                if !(200 ... 299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                NetworkLogger.log(response: response)
                
                return data
            }
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
