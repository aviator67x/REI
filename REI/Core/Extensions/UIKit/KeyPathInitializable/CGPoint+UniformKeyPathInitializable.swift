//
//  CGPoint+UniformKeyPathInitializable.swift
//  hwyhaul-driver
//
//  Created by Georhii Kasilov on 13.03.2021.
//

import UIKit

extension CGPoint: UniformKeyPathInitializable {
    public typealias Value = CGFloat
}

extension CGPoint {
    var all: CGFloat {
        get { -1 }
        set { (x, y) = (newValue, newValue) }
    }
}
