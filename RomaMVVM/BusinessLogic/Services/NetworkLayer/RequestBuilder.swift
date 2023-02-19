//
//  File.swift
//  CollectionComposition
//
//  Created by User on 12.02.2023.
//

import Combine
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndPoint: RequestBuilder {
    var baseURL: URL { get }
    var path: String { get }
    var query: [String: String]? { get }
    var method: HTTPMethod { get }
//    var task: HTTPTask { get }
    var headers: [String: String] { get }
    var body: Data? { get }

    func getURL() -> URL?
}

protocol RequestBuilder {
    func buildRequest() -> URLRequest?
}

extension EndPoint {
    var baseURL: URL {
//    URL(string: "https://api.backendless.com/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B")!
        AppConfigurationImpl().baseURL
    }
    
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
//        var components = URLComponents()
        var queryItems = [URLQueryItem]()
//        components.scheme = "https"
//        components.host = baseURL
//        components.path = path
//
        query?.forEach { item in
            let urlQueryItem = URLQueryItem(name: item.key, value: item.value)
            queryItems.append(urlQueryItem)
        }
//        components.queryItems = queryItems
//        return components.url
        if #available(iOS 16.0, *) {
            return baseURL.appendingPathComponent(path).appending(queryItems: queryItems)
        } else {
            // Fallback on earlier versions
            return nil
        }
               
    }
}

enum AuthEndPoint: EndPoint {
    case login(model: SignInRequest)
    case signUp(model: SignUpRequest)
    case recoverPassword

//    var baseURL: String {
//        "api.backendless.com"
//    }

    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .signUp:
            return "/data/Users"
        case .recoverPassword:
            return "/users/restorepassword/:userIdentity"
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
