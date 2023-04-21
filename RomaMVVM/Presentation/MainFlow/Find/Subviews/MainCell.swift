//
//  MainCell.swift
//  RomaMVVM
//
//  Created by User on 21.04.2023.
//

import Foundation
import UIKit
import Kingfisher

final class MainCell: UICollectionViewListCell {
    static let reusedidentifier = String(describing: MainCell.self)
    
    let imageView = UIImageView()
    let streetLabel = UILabel()
    let ortLabel = UILabel()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 3
     
        [streetLabel, ortLabel].forEach { label in
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView) {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        contentView.addSubview(stackView) {
            $0.leading.bottom.equalToSuperview().inset(20)
        }
        stackView.addArrangedSubviews([streetLabel, ortLabel])
    }
    
    func setupCell(_ model: MainCellModel) {
        imageView.kf.setImage(with: model.image, placeholder: UIImage(systemName: "house.lodge.circle"))
        streetLabel.text = model.street
        ortLabel.text = "\(model.ort), \u{20AC} \(model.price) k.k."
    }
}
