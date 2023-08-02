//
//  UserDataCellModel.swift
//  REI
//
//  Created by user on 31.03.2023.
//

import Foundation

struct UserDataCellModel: Hashable {
    let name: String
    let email: String
    let image: ImageResource
}

struct ProfileCollection {
    var section: ProfileSection
    var items: [ProfileItem]
}

enum ProfileSection: Hashable {
    case userData
    case details
    case button
}

enum ProfileItem: Hashable {
    case userData(UserDataCellModel)
    case plain(Titles)
    case button
}

enum Titles: String, Hashable {
    case name = "Name"
    case email = "Email"
    case dateOfBirth = "Date of Birth"
    case password = "Password"
}


