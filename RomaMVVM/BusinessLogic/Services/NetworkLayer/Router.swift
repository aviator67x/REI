////
////  NetworkService.swift
////  NetworkLayer
////
////  Created by Malcolm Kumwenda on 2018/03/07.
////  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
////
//
//import Foundation
//
//public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()
//
//protocol NetworkRouter: AnyObject {
//    associatedtype T: EndPoint
//    func request(_ route: T)
//    func cancel()
//}
//
//class Router<T: EndPoint>: NetworkRouter {
//    private var task: URLSessionTask?
//    
//    func request(_ route: T) {
//        let session = URLSession.shared
//        do {
//            let request = try self.buildRequest(from: route)
////            NetworkLogger.log(request: request)
//            } catch {
//          print(error)
//        }
//    }
//    
//    func cancel() {
//        self.task?.cancel()
//    }
//    
//    fileprivate func buildRequest(from route: T) throws -> URLRequest {
//        
//        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
//                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
//                                 timeoutInterval: 10.0)
//        
//        request.httpMethod = route.method.rawValue
//        do {
//            switch route.task {
//            case .request:
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            case .requestParameters(let bodyParameters,
//                                    let bodyEncoding,
//                                    let urlParameters):
//                
//                try self.configureParameters(bodyParameters: bodyParameters,
//                                             bodyEncoding: bodyEncoding,
//                                             urlParameters: urlParameters,
//                                             request: &request)
//                
//            case .requestParametersAndHeaders(let bodyParameters,
//                                              let bodyEncoding,
//                                              let urlParameters,
//                                              let additionalHeaders):
//                
//                self.addAdditionalHeaders(additionalHeaders, request: &request)
//                try self.configureParameters(bodyParameters: bodyParameters,
//                                             bodyEncoding: bodyEncoding,
//                                             urlParameters: urlParameters,
//                                             request: &request)
//            }
//            return request
//        } catch {
//            throw error
//        }
//    }
//    
//    fileprivate func configureParameters(bodyParameters: Parameters?,
//                                         bodyEncoding: ParameterEncoding,
//                                         urlParameters: Parameters?,
//                                         request: inout URLRequest) throws {
//        do {
//            try bodyEncoding.encode(urlRequest: &request,
//                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
//        } catch {
//            throw error
//        }
//    }
//    
//    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
//        guard let headers = additionalHeaders else { return }
//        for (key, value) in headers {
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//    }
//    
//}
//
