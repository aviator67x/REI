//
//  DistanceCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class DistanceCell: UICollectionViewCell {
    static let reusedidentifier = String(String(describing: DistanceCell.self))

    private let distanceLabel = UILabel()

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
        distanceLabel.backgroundColor = .secondarySystemBackground
        distanceLabel.bordered(width: 1, color: .lightGray)
        distanceLabel.layer.cornerRadius = 6
        distanceLabel.textAlignment = .center
    }

    private func setupLayout() {
        contentView.addSubview(distanceLabel) {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(60)
        }
    }

    private func setupBinding() {}

    func setupCell(with km: String) {
        distanceLabel.text = km
    }
}
