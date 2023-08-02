//
//  BackgroundCell.swift
//  REI
//
//  Created by User on 04.04.2023.
//

import Foundation
import UIKit

final class BackgroundCell: UICollectionViewListCell {
    private let label = UILabel()
    
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
        label.backgroundColor = .systemTeal
        contentView.backgroundColor = .systemTeal
    }

    private func setupLayout() {
        contentView.addSubview(label) {
            $0.edges.equalToSuperview()
            $0.height.equalTo(200)
        }
    }

    private func setupBinding() {}

    func setupCell(with title: String) {}
}
