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

    private let distanceButton = UIButton()

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
        distanceButton.backgroundColor = .secondarySystemBackground
        distanceButton.bordered(width: 1, color: .lightGray)
        distanceButton.layer.cornerRadius = 6
        distanceButton.setTitleColor(.black, for: .normal)
    }

    private func setupLayout() {
        contentView.addSubview(distanceButton) {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(60)
        }
    }

    private func setupBinding() {}

    func setupCell(with km: String) {
        distanceButton.setTitle(km, for: .normal)
    }
}
