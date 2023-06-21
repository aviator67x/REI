//
//  UIView+layout.swift
//  RomaMVVM
//
//  Created by User on 18.01.2023.
//

import UIKit
import SnapKit

extension UIView {
    
    func layout(using closure: (ConstraintMaker) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints(closure)
    }

    func addSubview(_ view: UIView, using closure: (ConstraintMaker) -> Void) {
        addSubview(view)
        view.layout(using: closure)
    }
}

