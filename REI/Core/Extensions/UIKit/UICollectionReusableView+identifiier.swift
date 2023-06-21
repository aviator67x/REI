//
//  UICollectionReusableView+identifiier.swift
//  RomaMVVM
//
//  Created by User on 07.05.2023.
//

import UIKit

extension UICollectionReusableView {
    static var reusableIdentifier: String {
        return String (describing: self)
    }
}
