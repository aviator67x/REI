//
//  TextFieldValidationService.swift
//  RomaMVVM
//
//  Created by User on 26.01.2023.
//

import Foundation

enum State: Equatable {
    case valid
    case invalid(errorMessage: String?)
}

final class TextFieldValidator {
    
    // MARK: Private properties
    private let type: TextFieldType
    
    // MARK: Life cycle
    
    init(type: TextFieldType) {
        self.type = type
    }
    
    // MARK: Methods
    func validateText(text: String?) -> State {
        if let text = text, text.isEmpty {
//            return .valid
            return .invalid(errorMessage: "Empty text for email")
        }
        if !performValidation(of: text ?? "", with: type.symbolCountValidator) {
            if let text = text, text.count > 9 {
                return .invalid(errorMessage: type.maxSymbolsErrorMessage)
            } else {
              return .invalid(errorMessage: type.minSymbolsErrorMessage)
            }
        } else if !performValidation(of: text ?? "", with: type.regExValidators) {
           return .invalid(errorMessage: type.regExtErrorMessage)
        } else {
            return .valid
        }
    }

    func performValidation(of text: String, with validators: [Validable]) -> Bool {
        var shouldRemoveAdditionalCharacters = false
        switch type {
        case .phone, .phoneForPasswordRecovery: shouldRemoveAdditionalCharacters = true
        default: break
        }
        return validators
            .first(where: { !$0.isValid(text, shouldRemoveAdditionalCharacters: shouldRemoveAdditionalCharacters)
            }) == nil
    }
}
