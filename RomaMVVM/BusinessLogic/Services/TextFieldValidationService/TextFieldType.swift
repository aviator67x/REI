//
//  TextFieldType.swift
//  Hydrostasis
//
//  Created by Gorilka on 3/10/19.
//  Copyright © 2019 Hydrostasis Inc. All rights reserved.
//

import UIKit

public enum TextFieldType {
    case phoneOrEmail
    case email
    case emailForPasswordRecovery
    case password
    case passwordRecovery
    case passwordWithoutVerification
    case phone
    case phoneForPasswordRecovery
    case nickName
    case userName
    case confirmPassword
    case confirmNewPassword
    case fullName
    case city
}

extension TextFieldType {
    var keyboardType: UIKeyboardType {
        switch self {
        case .phoneOrEmail: return .emailAddress
        case .email, .emailForPasswordRecovery: return .emailAddress
        case .password: return .alphabet
        case .passwordRecovery: return .alphabet
        case .phone, .phoneForPasswordRecovery: return .decimalPad
        case .nickName: return .default
        case .userName: return .alphabet
        case .confirmPassword, .confirmNewPassword: return .alphabet
        case .fullName: return .default
        case .passwordWithoutVerification:
            return .alphabet
        case .city: return .alphabet
        }
    }
    
    var leftImage: UIImage? {
        let imageName: String = ""
        switch self {
        default: break
        }
        
        return UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
    }
    
    var rightImage: UIImage? {
        var imageName: String = ""
        switch self {
        case .password: imageName = "eye.slash"
        case .passwordRecovery: imageName = "eye.slash"
        case .email, .emailForPasswordRecovery: imageName = "multiply.circle"
        case .phone, .phoneForPasswordRecovery: imageName = "multiply.circle"
        case .nickName: imageName = "multiply.circle"
        case .userName: imageName = "multiply.circle"
        case .confirmPassword, .confirmNewPassword: imageName = "eye.slash"
        case .fullName: imageName = "multiply.circle"
        case .phoneOrEmail: return nil
        case .passwordWithoutVerification: imageName = "eye.slash"
        case .city: imageName = "multiply.circle"
        }
        
        return UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
    }
    
    var placeholder: NSAttributedString {
        var text: String!
        switch self {
        case .phoneOrEmail: text = "Phone number or email"
        case .email, .emailForPasswordRecovery: text = "Email"
        case .password: text = "Password"
        case .passwordRecovery: text = "New password"
        case .phone, .phoneForPasswordRecovery: text = "Phone number"
        case .nickName: text = "Nickname"
        case .userName: text = "Full name"
        case .confirmPassword: text = "Confirm password"
        case .confirmNewPassword: text = "Confirm password"
        case .fullName: text = "Full name"
        case .passwordWithoutVerification:
            text = "Password"
        case .city: text = "Your City"
        }
        
        let attibutes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        return NSAttributedString(string: text, attributes: attibutes)
    }
    
    var needsSecureTextEntry: Bool {
        switch self {
        case .passwordWithoutVerification: return true
        case .password: return true
        case .confirmPassword: return true
        default: return false
        }
    }
    
    var regExValidators: [ValidatorType] {
        switch self {
        case .phoneOrEmail: return [.email]
        case .email, .emailForPasswordRecovery: return [.email]
        case .password, .passwordRecovery: return [.password]
        case .phone, .phoneForPasswordRecovery: return [.onlyDigits]
        case .nickName: return [.nickname]
        case .userName: return [.alphanumericExtended]
        case .confirmPassword, .confirmNewPassword: return [.password]
        case .fullName: return [.fullname]
        case .passwordWithoutVerification:
            return []
        case .city: return [.city]
        }
    }
    
    var symbolCountValidator: [ValidatorType] {
        switch self {
        case .phoneOrEmail: return []
        case .email, .emailForPasswordRecovery: return []
        case .phone, .phoneForPasswordRecovery: return [.length(min: 9, max: 9)]
        case .password, .passwordRecovery: return []
        case .nickName: return [.length(min: 8, max: 20)]
        case .userName: return [.length(min: 2, max: 35)]
        case .confirmPassword, .confirmNewPassword: return []
        case .fullName: return [.length(min: 2, max: 35)]
        case .passwordWithoutVerification: return []
        case .city: return [.length(min: 2, max: 50)]
        }
    }
    
    var minSymbolsErrorMessage: String? {
        switch self {
        case .phone, .phoneForPasswordRecovery: return "Looks like your phone number may be incorrect. Please try entering you full number."
        case .nickName: return "Please enter minimum 8 letters"
        case .userName: return "Please enter minimum 2 letters"
        case .fullName: return "Please enter minimum 2 letters"
        case .city: return "Please enter minimum 2 letters"
        default: return "" // fatalError("Add additional cases")
        }
    }
    
    var maxSymbolsErrorMessage: String? {
        switch self {
        case .nickName: return "Please enter maximum 20 symbols"
        case .userName: return "Please enter maximum 35 symbols"
        case .fullName: return "Please enter maximum 35 symbols"
        case .city: return "Please enter maximum 50 symbols"
        default: fatalError("Add additional cases")
        }
    }
    
    var regExtErrorMessage: String? {
        switch self {
        case .phoneOrEmail:
            return "To long nickname"
        case .password, .passwordRecovery:
            return "Password doesn't meet minimal requirements"
        case .email, .emailForPasswordRecovery:
            return "Please enter valid email.\nExapmle: example@domain.com"
        case .phone, .phoneForPasswordRecovery:
            return "Please enter valid phone number"
        case .nickName:
            return "Please enter only Latin letters, numbers and common punctuation symbols"
        case .userName:
            return "The username should contain only Cyrillic or Latin letters, space and the following characters: hyphen and apostroph."
        case .confirmPassword, .confirmNewPassword:
            return "The passwords don't match"
        case .fullName:
            return "The username should contain only Cyrillic or Latin letters, space and the folowing characters: hyphen '-' and apostrophe ' ."
        case .passwordWithoutVerification:
            return "Invalid login or password"
        case .city:
            return "Please enter valid city name"
        }
    }
    
    var headerTitle: String {
        switch self {
        case .phoneOrEmail: return "Phone or email"
        case .email, .emailForPasswordRecovery: return "Email"
        case .password, .passwordRecovery: return "Password"
        case .passwordWithoutVerification: return "Password"
        case .phone, .phoneForPasswordRecovery: return "Phone"
        case .nickName: return "Nickname"
        case .userName: return "User name"
        case .confirmPassword, .confirmNewPassword: return "Confirm password"
        case .fullName: return "Full name"
        case .city: return "City"
        }
    }
}
