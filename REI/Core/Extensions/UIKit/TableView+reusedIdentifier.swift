//
//  TableView+reusedIdentifier.swift
//  REI
//
//  Created by User on 07.08.2023.
//

import UIKit

extension UITableViewCell {
    static var reusableIdentifier: String {
        return String (describing: self)
    }
}
