//
//  PriceHeaderView.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class HeaderView: UICollectionReusableView {
    static let identifier = String(describing: HeaderView.self)
    let stack = UIStackView()
    let signImageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(stack) {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(150)
            $0.bottom.equalToSuperview()
        }
        
        signImageView.snp.makeConstraints {
            $0.width.equalTo(20)
        }

        stack.addArrangedSubviews([signImageView, label])
    }

     func setupUI(text: String, imageName: String) {
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = text
        
        signImageView.image = UIImage(systemName: imageName)
        signImageView.tintColor = .black
        
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 6
    }
}
