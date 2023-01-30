//
//  Optional+extension.swift
//  RomaMVVM
//
//  Created by User on 30.01.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var isNotEmpty: Bool {
        return !(self?.isEmpty ?? true)
    }

    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    var isNil: Bool {
        return self == nil
    }
}
