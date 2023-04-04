//
//  YearCell.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import Foundation
import UIKit

final class DetailedCell: UICollectionViewCell {
    static let identifier = "YearCell"
    let titleLable = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(titleLable) {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }

    func setupCell(title: String) {
        titleLable.text = title
    }
}

  
