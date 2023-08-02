//
//  SearchModels.swift
//  REI
//
//  Created by User on 04.04.2023.
//

import Foundation

struct UserProfileCellModel: Hashable {
    let name: String
    let email: String
    let image: ImageResource
}

enum SettingsSection: CaseIterable {
    case userProfile
    case profile
    case terms
    case company
}

enum SettingsItem: Hashable {
    case userProfile(userModel: UserProfileCellModel)
    case plain(title: String)
}
