//
//  ValidatorType.swift
//  Hydrostasis
//
//  Created by Gorilka on 3/10/19.
//  Copyright © 2019 Hydrostasis Inc. All rights reserved.
//

import Foundation

protocol Validable {
    func isValid(_ text: String?, shouldRemoveAdditionalCharacters: Bool) -> Bool
}

enum ValidatorType {
    case length(min: Int, max: Int)
    case notEquals(string: String)
    case onlyDigits
    case alphanumeric
    case alphanumericExtended
    case phoneFormat
    case onlyAlphabet
    case email
    case password
    case nickname
    case fullname
    case city
}

extension ValidatorType: Validable {
    func isValid(_ text: String?, shouldRemoveAdditionalCharacters: Bool) -> Bool {
        switch self {
        case let .length(min, max):
            var digitText: String?
            if shouldRemoveAdditionalCharacters {
                digitText = text?
                    .replacingOccurrences(of: "$", with: "")
                    .replacingOccurrences(of: ",", with: "")
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "-", with: "")
            } else {
                digitText = text
            }
            return digitText != nil && digitText!.count >= min && digitText!.count <= max
        case .onlyDigits: return text =~ RegEx.numeric.rawValue
        case .phoneFormat: return text =~ RegEx.phoneWithCode.rawValue
        case .onlyAlphabet: return text =~ RegEx.alphabetic.rawValue
        case .alphanumeric: return text =~ RegEx.alphanumeric.rawValue
        case .alphanumericExtended: return text =~ RegEx.alphanumExtended.rawValue
        case .email: return text =~ RegEx.email.rawValue
        case .nickname: return text =~ RegEx.nickname.rawValue
        case .fullname: return text =~ RegEx.fullname.rawValue
        case let .notEquals(string): return text != string
        case .password: return text =~ RegEx.password.rawValue
        case .city: return text =~ RegEx.city.rawValue
        }
    }
}
