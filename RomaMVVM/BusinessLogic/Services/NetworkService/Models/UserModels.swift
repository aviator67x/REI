//
//  UserModels.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation

struct UpdateUserRequestModel: Encodable {
    let imageURL: String
    let id: String
}

struct UpdateUserResponseModel: Decodable {
    let id: String
    let name: String
    let email: String
    let imageURL: String
    let userStatus: String

    enum CodingKeys: String, CodingKey {
        case name, email, imageURL, userStatus
        case id = "ownerId"
    }
}

struct UpdateAvatarResponceModel: Decodable {
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "fileURL"
    }
}
