//
//  UIView+isHidden.swift
//  RomaMVVM
//
//  Created by User on 24.04.2023.
//

import Foundation
import UIKit

extension UIView {
    var isHiddenInStackView: Bool {
        get {
            return isHidden
        }
        set {
            if isHidden != newValue {
                isHidden = newValue
            }
        }
    }
}
