//
//  Endpoint.swift
//  NetworkingDemo
//
//  Created by Roman Savchenko on 20.02.2023.
//

import Foundation

enum RequestBody {
    case rawData(Data)
    case encodable(Encodable)
}

typealias HTTPQueries = [String: String]
typealias HTTPHeaders = [String: String]

protocol Endpoint: RequestBuilder {
    var baseURL: URL? { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var queries: HTTPQueries { get }
    var headers: HTTPHeaders { get }
    var body: RequestBody? { get }
}

protocol RequestBuilder {
    func build(baseURL: URL, encoder: JSONEncoder) throws -> URLRequest
}

extension Endpoint {
    var baseURL: URL? { return nil }
    
    var queries: HTTPQueries { [:] }
    
    func build(baseURL: URL, encoder: JSONEncoder) throws -> URLRequest {
        var fullURL = self.baseURL ?? baseURL
        if let path = path {
            fullURL = fullURL.appendingPathComponent(path)
        }
        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: true) else {
//            return nil
            throw RequestBuilderError.unableToCreateComponents(code: 100, error: "Unable to create components")
        }
        components.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let requestURL = components.url else {
            throw RequestBuilderError.unableToBuildUrl
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        if let body = body {
            switch body {
            case .rawData(let data):
                request.httpBody = data
                
            case .encodable(let model):
                guard let data = try? encoder.encode(model) else {
                    throw RequestBuilderError.unableToBuildUrl
                }
                request.httpBody = data
            }
        }
        headers.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
