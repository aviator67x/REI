//
//  UserDataCell.swift
//  RomaMVVM
//
//  Created by User on 04.04.2023.
//

import Foundation
import UIKit

final class UserDataCell: UICollectionViewCell {
    static var reuseidentifier: String {
        return String(describing: Self.self)
    }
    private let userView = UIView()
    private let photo = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let spacer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        photo.layer.cornerRadius = 60
        photo.clipsToBounds = true
        addSubview(userView) {
            $0.edges.equalToSuperview()
        }
        userView.addSubview(photo) {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(120)
            $0.top.equalToSuperview().offset(10)
        }
        userView.addSubview(nameLabel) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(photo.snp.bottom).offset(5)
        }
        userView.addSubview(emailLabel) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom)
        }
        userView.addSubview(spacer) {
            $0.width.bottom.equalToSuperview()
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.height.equalTo(50)
        }
    }
    
    func setup(_ user: UserDataCellModel) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        photo.setIMage(imageResource: user.image)
        photo.tintColor = .systemGray
    }
}

