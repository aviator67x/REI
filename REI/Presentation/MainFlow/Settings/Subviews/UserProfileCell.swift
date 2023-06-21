//
//  UserProfileCell.swift
//  RomaMVVM
//
//  Created by User on 04.04.2023.
//

import Foundation
import Kingfisher
import UIKit

final class UserProfileCell: UICollectionViewCell {
    static let identifier = "UserProfileCell"
    private let photo = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()

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
        photo.layer.cornerRadius = 40
        photo.clipsToBounds = true
        contentView.addSubview(photo) {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(80)
            $0.leading.equalToSuperview().offset(20)
        }
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel) {
            $0.centerY.equalToSuperview().offset(-10)
            $0.leading.equalTo(photo.snp.trailing).offset(20)
            $0.width.equalTo(200)
        }
        emailLabel.numberOfLines = 0
        contentView.addSubview(emailLabel) {
            $0.centerY.equalToSuperview().offset(20)
            $0.leading.equalTo(photo.snp.trailing).offset(20)
            $0.width.equalTo(200)
        }
    }

    func setupCell(model: UserProfileCellModel) {
        let imageResouce = model.image
        photo.setIMage(imageResource: imageResouce)
        photo.tintColor = .systemGray
        nameLabel.text = model.name
        emailLabel.text = model.email
    }
}
