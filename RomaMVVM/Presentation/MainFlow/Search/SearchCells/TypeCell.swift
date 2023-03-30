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
    
    private let typeButton = UIButton()
    
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
        typeButton.backgroundColor = .secondarySystemBackground
        typeButton.bordered(width: 1, color: .lightGray)
        typeButton.layer.cornerRadius = 6
        typeButton.setTitleColor(.black, for: .normal)
    }

    private func setupLayout() {
        contentView.addSubview(typeButton) {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(100)
        }
    }

    private func setupBinding() {}

    func setupCell(with title: String) {
        typeButton.setTitle(title, for: .normal)
    }
}

