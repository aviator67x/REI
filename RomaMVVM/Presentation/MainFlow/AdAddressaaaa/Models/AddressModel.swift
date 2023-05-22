//
//  AddressCellModel.swift
//  RomaMVVM
//
//  Created by User on 18.05.2023.
//

import Foundation

struct AddressModel {
    var ort: String? = nil
    var street: String? = nil
    var house: String? = nil
    var isValid: Bool = false
    var isOrtValid: Bool = true
    var isStreetValid: Bool = true
    var isHouseValid: Bool = true
}
