//
//  RegEx.swift
//  Hydrostasis
//
//  Created by Gorilka on 3/10/19.
//  Copyright © 2019 Hydrostasis Inc. All rights reserved.
//

import Foundation

infix operator =~

enum RegEx: String {
    case alphabetic = "^[A-Za-z ]+$"
    case numeric = "^[0-9,$ ]+$"
    case alphanumeric = "^[A-Za-z0-9 -]+.$"
    case alphanumExtended = "^[A-Za-z'0-9 @,;:_.!#%'+^\"$*()&?\\/|\\[\\]!{}-]+.$"

    case email = "(^[A-Z0-9a-z!#$%&'*+-/=?^_`{|}~]{1,64})([@]([A-Z0-9a-z!#$%&'*+-/=?^_`{|}~]{1,63}))[.]([A-Za-z]{2,6})"
    case phoneWithCode = "^(?=.*[0])[0-9+ ]{13}$"
    case phoneWithoutCode = "^(?=.*[0])[0-9+ ]{10}$"
    case phoneWithPlus = "^(?=.*[0])[0-9 ]{12}$"
    case password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!#$%^&*()@?=_+-])[A-Za-z\\d!#$%^&*()@?=_+-]{8,24}"
    case nickname = "^[a-zA-Z0-9-_.']+$"
    case fullname = "^[а-яА-ЯёЁa-zA-Z'‘’ -]+$"
    case city = "^[A-Za-z'‘’ -]+$"

}

extension String {
    static func =~ (input: String?, pattern: String) -> Bool {
        guard let text = input else { return false }

        return NSPredicate(format: "%@ MATCHES %@", text, pattern).evaluate(with: text)
    }
}
