////
////  File.swift
////  CollectionComposition
////
////  Created by User on 12.02.2023.
////
//
//import Combine
//import Foundation
//
//
//
//protocol EndPoint: RequestBuilder {
//    var baseURL: URL { get }
//    var path: String { get }
//    var queryParameters: [String: String] { get }
//    var method: HTTPMethod { get }
//    var headers: [String: String] { get }
//    var body: Data? { get }
//
//    func getURL() -> URL?
//}
//
//protocol RequestBuilder {
//    func buildRequest() -> URLRequest
//}
//
//extension EndPoint {
//    var baseURL: URL {
//        AppConfigurationImpl().baseURL
//    }
//    
//    func buildRequest() -> URLRequest {
//        guard let url = getURL() else {
//            fatalError()
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//
//        for header in headers {
//            request.addValue(header.value, forHTTPHeaderField: header.key)
//        }
//
//        request.httpBody = body
//        return request
//    }
//    
//    var queryParameters: [String:String] {
//        [:]
//    }
//
//    func getURL() -> URL? {
//        let fullURL = baseURL.appendingPathComponent(path)
//        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: true) else {
//            return nil
//        }
//        components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//        return components.url
//    }
//}
//
//
//protocol Requestable {
//  
//    func request<T: Decodable>(_ request: EndPoint, decoder: JSONDecoder) -> AnyPublisher<T, NetworkError>
//}
//
//class NetworkRequestable: Requestable {
//    let session: URLSession
//    
//    init(session: URLSession) {
//        self.session = session
//    }
//    
//    public func request<T>(_ request: EndPoint, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, NetworkError> where T: Decodable {
//        return session
//            .dataTaskPublisher(for: request.buildRequest())
//            .tryMap { output in
//                guard output.response is HTTPURLResponse else {
//                    throw NetworkError.serverError(code: 0, error: "Server error")
//                }
//                return output.data
//            }
//            .decode(type: T.self, decoder: decoder)
//            .mapError { error in
//                NetworkError.invalidJSON(String(describing: error))
//            }
//            .eraseToAnyPublisher()
//    }
//}
