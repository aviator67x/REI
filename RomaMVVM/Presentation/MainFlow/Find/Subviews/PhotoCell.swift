//
//  PhotoCell.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Foundation
import UIKit
import Kingfisher

final class PhotoCell: UICollectionViewListCell {
    static let reusedidentifier = String(describing: PhotoCell.self)
    
    let imageView = UIImageView()
    let streetLabel = UILabel()
    let ortLabel = UILabel()
    let sqmLabel = UILabel()
    let priceValueLabel = UILabel()
    let stackView = UIStackView()
    let heartButton = UIButton()
    let signsButton = UIButton()
   
    
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
     
        [streetLabel, ortLabel, sqmLabel, priceValueLabel].forEach { label in
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        heartButton.largeContentImageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        heartButton.imageView?.contentMode = .scaleAspectFill
//        heartButton.clipsToBounds = true
        heartButton.tintColor = .white
        
        let buttonTitle = "\u{2B6F}  \u{95E8} \u{27C1}"
        signsButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView) {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        contentView.addSubview(stackView) {
            $0.leading.bottom.equalToSuperview().inset(20)
        }
        stackView.addArrangedSubviews([streetLabel, ortLabel, sqmLabel, priceValueLabel])
        
        contentView.addSubview(heartButton) {
            $0.size.equalTo(40)
            $0.trailing.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(signsButton) {
            $0.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    func setupCell(_ model: PhotoCellModel) {
        imageView.kf.setImage(with: model.image)
        streetLabel.text = model.street
        ortLabel.text = model.ort
        sqmLabel.text = "\(model.livingArea) sqm / \(model.square) sqm \u{00B7} \(model.numberOfRooms) rooms"
        priceValueLabel.text = "\u{20AC} \(String(model.price)) k.k."
    }
}
