//
//  PriceCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class PriceCell: UICollectionViewCell {
    static let reusedidentifier = String(String(describing: PriceCell.self))
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        setupLayout()
        setupUI()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        priceLabel.bordered(width: 1, color: .red)
        priceLabel.layer.cornerRadius = 6
        priceLabel.text = "Pirce in Euro"
    }

    private func setupLayout() {
        contentView.addSubview(priceLabel) {
            $0.edges.equalToSuperview()
            $0.width.equalTo(200)
        }
    }

    private func setupBinding() {}

    func setupCell(with price: Int) {}
}

