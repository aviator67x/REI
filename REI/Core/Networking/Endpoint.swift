//
//  Endpoint.swift
//  NetworkingDemo
//
//  Created by user on 20.02.2023.
//
import Foundation

enum RequestBody {
    case rawData(Data)
    case encodable(Encodable)
    case multipartBody([MultipartItem])
}

typealias HTTPQueries = [String: String]
typealias HTTPHeaders = [String: String]

protocol RequestBuilder {
    func build(baseURL: URL, encoder: JSONEncoder, plugins: [Plugin]) throws -> URLRequest
}

protocol Endpoint: RequestBuilder {
    var baseURL: URL? { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var queries: HTTPQueries { get }
    var headers: HTTPHeaders { get }
    var body: RequestBody? { get }
}

extension Endpoint {
    var baseURL: URL? { return nil }

    var queries: HTTPQueries { [:] }

    func build(baseURL: URL, encoder: JSONEncoder, plugins: [Plugin]) throws -> URLRequest {
        var fullURL = self.baseURL ?? baseURL
        if let path = path {
            fullURL = fullURL.appendingPathComponent(path)
        }
        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: true) else {
            throw RequestBuilderError.unableToCreateComponents
        }
        components.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let requestURL = components.url else {
            throw RequestBuilderError.unableToBuildUrl
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        plugins.forEach {$0.modifyRequest(&request)}
        headers.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = body {
            switch body {
            case let .rawData(data):
                request.httpBody = data

            case let .encodable(model):
                guard let data = try? encoder.encode(model) else {
                    throw RequestBuilderError.unableToEncode
                }
                request.httpBody = data

            case let .multipartBody(multipartItems):
                let multipartData = getMultipartData(multipartItems: multipartItems)
                request.httpBody = multipartData.data
                request.setValue(
                    "multipart/form-data; boundary=\(multipartData.boundary)",
                    forHTTPHeaderField: "Content-Type"
                )
            }
        }
        return request
    }

    private func getMultipartData(multipartItems: [MultipartItem]) -> MultipartData {
        let boundary = UUID().uuidString

        guard !multipartItems.isEmpty else { return MultipartData(data: Data(), boundary: boundary) }

        let data = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"

        for item in multipartItems {
            data.append(boundaryPrefix)
            data.append(item.convert())
        }

        data.append("--\(boundary)--\r\n")

        return MultipartData(data: data as Data, boundary: boundary)
    }

    func buildQuery(searchParams: [SearchParam]) -> [String: String]? {
        return Search.searchProperty(searchParams).query
    }
}

