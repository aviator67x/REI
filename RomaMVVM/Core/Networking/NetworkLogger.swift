//
//  NetworkLogger.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/11.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

fileprivate enum LogEvent: String {
   case e = "[‼️]" // error
   case i = "[ℹ️]" // info
   case d = "[💬]" // debug
   case v = "[🔬]" // verbose
   case w = "[⚠️]" // warning
   case s = "[🔥]" // severe
}

struct NetworkLogger {
    static func log(request: URLRequest) {
        
        debugPrint("\n- - - - - - - - - - URLRequest details - - - - - - - - - -\n")
        defer { debugPrint("\n- - - - - - - - - -  END - - - - - - - - - -\n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
                        \(urlAsString)\n\n
                        \(method) \(path)?\(query) HTTP/1.1 \nHOST: \(host)\n
"""
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value)\n"
        }
        if let body = request.httpBody {
            logOutput += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        debugPrint(logOutput)
    }
    
    static func log(response: HTTPURLResponse) {
        debugPrint("\n- - - - - - - - - - HTTPURLResponse - - - - - - - - - -\n")
        defer { print("\n- - - - - - - - - -  END - - - - - - - - - -\n") }
        debugPrint("HTTPURLResponse status code is \(response.statusCode)")
    }
    
    static func log<T>(data: T) {
        debugPrint("\n- - - - - - - - - - DataFromDataTaskPublisher - - - - - - - - - -\n")
        defer { debugPrint("\n- - - - - - - - - -  END - - - - - - - - - -\n") }
        debugPrint("\(data)\n")
    }
}
