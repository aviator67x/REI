//
//  UserEndPoint.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation

enum UserEndPoint: Endpoint {
case deleteUser(id: String)
    
    var path: String? {
        switch self {
        case .deleteUser:
          return "/users/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .deleteUser:
            return .delete
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .deleteUser(id: let id):
            return ["user-token":id]
        }
    }
    
    var body: RequestBody? {
        switch self {
        case .deleteUser:
            return nil
        }
    }
    

    
   
}
