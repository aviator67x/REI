//
//  InstaAPIRequestBuilder.swift
//  RomaMVVM
//
//  Created by User on 30.01.2023.
//

import Foundation
import CombineNetworking

enum InstaAPIRequestBuilder: CNRequestBuilder {
    case requestForAccessToken(phone: String, password: String)
    case sendVerification(code: String)
    
    var path: String {
        switch self {
        case .requestForAccessToken: return "users/login"
        case .sendVerification: return "auth/send-confirm-code"
        }
    }
    
    var query: QueryItems? {
        switch self {
        case .requestForAccessToken: return nil
        default: return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .requestForAccessToken: return nil
        default: return nil
        }
    }
    
    var method: CombineNetworking.HTTPMethod {return .get}
    
    
}
