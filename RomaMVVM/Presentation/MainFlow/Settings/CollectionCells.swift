//
//  TableCell.swift
//  RomaMVVM
//
//  Created by User on 16.03.2023.
//

import Foundation
import UIKit
import Kingfisher

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
        }
        emailLabel.numberOfLines = 0
        contentView.addSubview(emailLabel) {
            $0.centerY.equalToSuperview().offset(10)
            $0.leading.equalTo(photo.snp.trailing).offset(20)
        }
    }

    func setupCell(model: UserProfileCellModel) {
        let imageResouce = model.image
        photo.setIMage(imageResource: imageResouce)
        nameLabel.text = model.name
        emailLabel.text = model.email
    }
}

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
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    func setupCell(title: String) {
        arrowView.image = UIImage(systemName: "chevron.right")
        titleLable.text = title
    }
}

final class ButtonCell: UICollectionViewCell {
    static let identifier = "ButtonCell"
    let titleLable = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(titleLable) {
            $0.center.equalToSuperview()
//            $0.leading.equalToSuperview().offset(20)
        }
    }

    func setupCell() {
        titleLable.text = "Log Out"
        titleLable.font = UIFont.systemFont(ofSize: 20)
        titleLable.textColor = .red
    }
}
