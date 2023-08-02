//
//  PlainCell.swift
//  REI
//
//  Created by User on 04.04.2023.
//

import Foundation
import UIKit
import Kingfisher
final class PlainCell: UICollectionViewCell {
    static let identifier = "PlainCell"
    let titleLable = UILabel()
    let arrowView = UIImageView()

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
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        contentView.addSubview(arrowView) {
            $0.height.equalTo(20)
            $0.width.equalTo(10)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    func setupCell(title: String) {
        arrowView.image = UIImage(systemName: "chevron.right")
        titleLable.text = title
    }
}
