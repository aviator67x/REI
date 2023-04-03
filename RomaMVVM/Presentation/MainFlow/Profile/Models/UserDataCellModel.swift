//
//  UserDataCellModel.swift
//  RomaMVVM
//
//  Created by Roman Savchenko on 31.03.2023.
//

import Foundation

struct UserDataCellModel: Hashable {
    let name: String
    let email: String
    let image: ImageResource
}

enum ProfileSection: Hashable {
    case userData
    case details
    case button
}

enum ProfileItem: Hashable {
    case userData(UserDataCellModel)
    case plain(String)
    case button
}

struct ProfileCollection {
    var section: ProfileSection
    var items: [ProfileItem]
}
