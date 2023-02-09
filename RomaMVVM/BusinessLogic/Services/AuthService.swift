//
//  AuthService.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 20.11.2021.
//

import Combine
import Foundation

enum CustomError: Error {
    case authError
}

struct SignInResponse: Decodable {
    let id: String
    let name: String
    let email: String
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case id = "ownerId"
        case name
        case email
        case accessToken = "user-token"
    }
}

struct SignUpResponse: Decodable {
    let id: String
    let name: String
    let email: String
    let accessToken: String
}

protocol AuthService {
    func signIn(email: String, password: String) -> AnyPublisher<SignInResponse, CustomError>
    func signUp(email: String, password: String) -> AnyPublisher<Bool, CustomError>
    func signInForToken(email: String, password: String) -> AnyPublisher<SignInResponse, Error>
}

class AuthServiceImpl: AuthService {
    func signIn(email: String, password: String) -> AnyPublisher<SignInResponse, CustomError> {
        Future<SignInResponse, CustomError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if password.count > 8 {
                    let model = SignInResponse(
                        id: UUID().uuidString,
                        name: "Username",
                        email: email,
                        accessToken: UUID().uuidString
                    )
                    promise(.success(model))
                } else {
                    promise(.failure(.authError))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func signUp(email: String, password: String) -> AnyPublisher<Bool, CustomError> {
        Future<Bool, CustomError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if password.count > 4 {
                    promise(.success(true))
                } else {
                    promise(.failure(.authError))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func signInForToken(email: String, password: String) -> AnyPublisher<SignInResponse, Error> {
//        var request: URLRequest
//        let baseURL =
//            "https://api.backendless.com/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B"
//        let path = "/users/login"
//        guard let url = URL(string: baseURL.appending(path)) else { fatalError() }
        var request = URLRequest(url: URL(string: "https://api.backendless.com/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/users/login")!)
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        struct SignInRequestModel: Encodable {
            var login: String
            var password: String
        }
        let requestModel = SignInRequestModel(login: email, password: password)
        
        

        let body = try? JSONEncoder().encode(requestModel)
        request.httpBody = body

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: SignInResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
