//
//  UIView+publishers.swift
//  RomaMVVM
//
//  Created by User on 08.05.2023.
//

import Foundation
import UIKit

extension UIView {
    func gesture(_ gestureType: GestureType = .tap()) ->
        GesturePublisher
    {
        .init(view: self, gestureType: gestureType)
    }
}
