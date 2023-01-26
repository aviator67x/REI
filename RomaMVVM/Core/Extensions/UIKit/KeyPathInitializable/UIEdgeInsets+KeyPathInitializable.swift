//
//  UIEdgeInsets+KeyPathInitializable.swift
//  hwyhaul-driver
//
//  Created by Georhii Kasilov on 13.03.2021.
//

import UIKit

extension UIEdgeInsets: UniformKeyPathInitializable {
    public typealias Value = CGFloat
}

public extension UIEdgeInsets {
    var vertical: CGFloat {
        get {
            if top == bottom {
                return top
            } else {
                return 0
            }
        }
        set {
            (top, bottom) = (newValue, newValue)
        }
    }

    var horizontal: CGFloat {
        get {
            if right == left {
                return right
            } else {
                return 0
            }
        }
        set {
            (right, left) = (newValue, newValue)
        }
    }

    var all: CGFloat {
        get {
            if right == left, bottom == top {
                return right
            } else {
                return 0
            }
        }
        set {
            (right, left, bottom, top) = (newValue, newValue, newValue, newValue)
        }
    }
}
