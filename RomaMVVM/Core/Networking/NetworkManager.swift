//
//  NetworkManager.swift
//  RomaMVVM
//
//  Created by user on 20.02.2023.
//

import Foundation
import Combine

protocol NetworkManager {
    func execute(request: URLRequest) -> AnyPublisher<Data, NetworkError>
}

class NetworkManagerImpl: NetworkManager {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func execute(request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return session.dataTaskPublisher(for: request)
            .mapError { error in
                return NetworkError.badURL(error)
            }
            .flatMap { output -> AnyPublisher<Data, NetworkError> in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.unknown)
                        .eraseToAnyPublisher()
                }
              
                switch httpResponse.statusCode {
                case 200...399:
                    return Just(output.data)
                        .setFailureType(to: NetworkError.self)
                        .eraseToAnyPublisher()
                    
                case 400...499:
                    return Fail(error: NetworkError.badRequest(code: 102, error: "Bad URL request"))
                        .eraseToAnyPublisher()
                    
                case 500...599:
                    return Fail(error: NetworkError.serverError(code: 103, error: "Server error"))
                        .eraseToAnyPublisher()
                    
                default:
                    return Fail(error: NetworkError.unknown)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}