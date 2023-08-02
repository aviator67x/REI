//
//  UICollectionView+dequeue.swift
//  REI
//
//  Created by User on 07.05.2023.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) {
        let identifier = cellClass.reusableIdentifier
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    func dedequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        let identifier = Cell.reusableIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("\(Cell.self) should be a \(UICollectionViewCell.self)")
        }

        return cell
    }
}
