//
//  File.swift
//  CollectionComposition
//
//  Created by User on 12.02.2023.
//

import Combine
import Foundation

enum Environment: String, CaseIterable {
    case development
    case staging
    case production
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPoint: RequestBuilder {
    var baseURL: String { get }
    var path: String { get }
    var query: [String: String]? { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }

    func getURL() -> URL?
}

protocol RequestBuilder {
    func buildRequest() -> URLRequest?
}

extension EndPoint {
    func buildRequest() -> URLRequest? {
        guard let url = getURL() else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        request.httpBody = body
        return request
    }

    func getURL() -> URL? {
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        components.scheme = "https"
        components.host = baseURL
        components.path = path

        query?.forEach { item in
            let urlQueryItem = URLQueryItem(name: item.key, value: item.value)
            queryItems.append(urlQueryItem)
        }
        components.queryItems = queryItems
        return components.url
    }
}

enum AuthEndPoint: EndPoint {
    case login(model: SignInRequest)
    case signUp(model: SignUpRequest)
    case recoverPassword

    var baseURL: String {
//        AppEnvironment.dev.rawValue
        "api.backendless.com"
    }

    var path: String {
        switch self {
        case .login:
            return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/users/login"
        case .signUp:
            return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/data/Users"
        case .recoverPassword:
            return "/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/users/restorepassword/:userIdentity"
        }
    }

    var query: [String: String]? {
        nil
    }

    var method: HTTPMethod {
        switch self {
        case .login, .signUp:
            return .post
        case .recoverPassword:
            return .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .login:
            return ["Content-Type": "application/json"]
        case .signUp:
            return ["Content-Type": "application/json"]
        case .recoverPassword:
            return [:]
        }
    }

    var body: Data? {
        switch self {
        case let .login(model: model):
            let data = try? JSONEncoder().encode(model)

            return data
        case let .signUp(model: model):
            let data = try? JSONEncoder().encode(model)

            return data
        case .recoverPassword:
            return nil
        }
    }
}

protocol Requestable {
    func request<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, NetworkError>
}

class NetworkRequestable: Requestable {
    public func request<T>(_ request: URLRequest) -> AnyPublisher<T, NetworkError> where T: Decodable {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, error: "Server error")
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                NetworkError.invalidJSON(String(describing: error))
            }
            .eraseToAnyPublisher()
    }
}
