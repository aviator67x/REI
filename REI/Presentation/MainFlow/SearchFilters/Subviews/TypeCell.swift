//
//  TypeCell.swift
//  REI
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class TypeCell: UICollectionViewListCell {    
    private let typeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        typeLabel.layer.masksToBounds = true
        typeLabel.layer.cornerRadius = 6
        typeLabel.textAlignment = .center
    }

    private func setupLayout() {
        contentView.addSubview(typeLabel) {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(100)
        }
    }

    private func setupBinding() {}

    func setupCell(with model: PropertyTypeCellModel) {
        isSelected = model.isSelected
        typeLabel.bordered(width: 1, color: isSelected ? .blue : .lightGray)
        typeLabel.backgroundColor = isSelected ? .systemTeal : .secondarySystemBackground
        switch model.propertyType {
        case .apartment:
            typeLabel.text = "apartment"            
        case .house:
            typeLabel.text = "house"
        case .land:
            typeLabel.text = "land"
        }
    }
}

