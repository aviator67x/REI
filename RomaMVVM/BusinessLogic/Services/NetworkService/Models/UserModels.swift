//
//  UserModels.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation

struct UpdateUserRequestModel: Encodable {
    let firstName: String?
    let lastName: String?
    let nickName: String?
    let imageURL: URL?
    let id: String
}

struct UpdateUserResponseModel: Decodable {
    let id: String
    let name: String
    let firstName: String?
    let lastName: String?
    let nickName: String?
    let email: String
    let imageURL: URL?
    let userStatus: String

    enum CodingKeys: String, CodingKey {
        case name, firstName, lastName, nickName, email, imageURL, userStatus
        case id = "ownerId"
    }
}

struct UpdateAvatarResponceModel: Decodable {
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "fileURL"
    }
}
