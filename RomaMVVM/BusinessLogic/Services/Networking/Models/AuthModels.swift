//
//  AuthModels.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation

struct SignInRequest: Encodable {
    var login: String
    var password: String
}

struct SignInResponse: Decodable {
    let id: String
    let name: String
    let email: String
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case id = "ownerId"
        case name
        case email
        case accessToken = "user-token"
    }
}

struct SignUpRequest: Encodable {
    var name, email, password: String
}

struct SignUpResponse: Decodable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case name, email, id = "ownerId"
    }
}
