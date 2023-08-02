//
//  YearCell.swift
//  REI
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

struct UniversalCellModel {
    let image: UIImage?
    let itemText: String
    let infoText: String
}

final class UniversalCell: UICollectionViewCell {
    private let itemImage = UIImageView()
    private let itemLabel = UILabel()
    private let infoLabel = UILabel()
    private let chevromImage = UIImageView()

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
        itemLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        itemImage.tintColor = .black
        chevromImage.image = UIImage(systemName: "chevron.right")
    }

    private func setupLayout() {
        contentView.addSubview(itemImage) {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.size.equalTo(20)
        }
        
        contentView.addSubview(chevromImage) {
            $0.centerY.equalTo(itemImage.snp.centerY)
            $0.height.equalTo(20)
            $0.width.equalTo(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(itemLabel) {
            $0.leading.equalTo(itemImage.snp.trailing).offset(6)
            $0.centerY.equalTo(itemImage.snp.centerY)
        }
        
        contentView.addSubview(infoLabel) {
            $0.leading.equalToSuperview().offset(46)
            $0.top.equalTo(itemLabel.snp.bottomMargin).offset(20)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupBinding() {}

    func setupCell(model: UniversalCellModel) {
        itemImage.image = model.image
        itemLabel.text = model.itemText
        infoLabel.text = model.infoText
    }
}

