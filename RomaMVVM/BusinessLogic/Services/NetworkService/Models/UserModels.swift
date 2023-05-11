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
    
    init(firstName: String? = nil, lastName: String? = nil, nickName: String? = nil, imageURL: URL?, id: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        self.imageURL = imageURL
        self.id = id
    }
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
    let favouriteHouses: [HouseResponseModel]?

    enum CodingKeys: String, CodingKey {
        case name, firstName, lastName, nickName, email, imageURL, userStatus, favouriteHouses
        case id = "objectId"
    }
}

struct UpdateAvatarResponceModel: Decodable {
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "fileURL"
    }
}

struct SaveToFavouriteResponseModel: Decodable {
    let one:  String
}
