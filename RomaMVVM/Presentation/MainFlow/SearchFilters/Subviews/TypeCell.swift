//
//  TypeCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class TypeCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: TypeCell.self))
    
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
        typeLabel.backgroundColor = .secondarySystemBackground
        typeLabel.bordered(width: 1, color: .lightGray)
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

    func setupCell(with title: String) {
        typeLabel.text = title
    }
}

