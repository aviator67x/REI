//
//  UserEndPoint.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation
import UIKit

enum UserEndPoint: Endpoint {
    case deleteUser(id: String)
    case logOut(token: String)
    case addAvatar(image: UIImage)
    
    var boundary: String {
        return UUID().uuidString
    }

    var path: String? {
        switch self {
        case .deleteUser:
            return "/data/Person/"
        case .logOut:
            return "/users/logout"
        case .addAvatar:
            return "/data/Users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .deleteUser:
            return .delete
        case .logOut:
            return .get
        case .addAvatar:
            return .post
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case let .deleteUser(id: id):
            return ["user-token": id]
        case .logOut(let token):
            return ["Content-Type": "application/json",
                    "user-token": token]
        case .addAvatar:
           return ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        }
    }

    var body: RequestBody? {
        switch self {
        case .deleteUser, .logOut:
            return nil
        case .addAvatar(image: let image):
           
            var data = Data()

            // Add the image data to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"\(image)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(image.pngData()!)

            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            return .rawData(data)
        }
    }
}
