//
//  UIView+Ext.swift
//  REI
//
//  Created by user on 12.02.2023.
//

import UIKit

extension UIView {
    func bordered(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    func rounded() {
        rounded(min(bounds.width, bounds.height) / 2)
    }

    func rounded(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
