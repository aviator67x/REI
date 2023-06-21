//
//  CGSize+UniformKeyPathInitializable.swift
//  hwyhaul-driver
//
//  Created by Georhii Kasilov on 13.03.2021.
//

import Foundation
import UIKit

extension CGSize: UniformKeyPathInitializable {
    public typealias Value = CGFloat
}

public extension CGSize {
    var all: CGFloat {
        get { return -1 }
        set { (width, height) = (newValue, newValue) }
    }
}
