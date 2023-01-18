//
//  Creatable.swift
//  RomaMVVM
//
//  Created by User on 18.01.2023.
//
import Foundation
import UIKit

protocol Creatable: AnyObject {}
extension NSObject: Creatable {}

extension Creatable where Self: NSObject {
    init(_ closure: (Self) -> Void) {
        self.init()
        closure(self)
    }

    @discardableResult
    func configure(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
