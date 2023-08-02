//
//  UIEdgeInsets+Ext.swift
//  REI
//
//  Created by user on 12.02.2023.
//

import UIKit

extension UIEdgeInsets {
//    convenience init(all value: CGFloat) {
//        self.init(top: value, left: value, bottom: value, right: value)
//    }

    static func all(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: value, left: value, bottom: value, right: value)
    }
}
