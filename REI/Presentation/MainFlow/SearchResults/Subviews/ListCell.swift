//
//  ListCell.swift
//  REI
//
//  Created by User on 21.04.2023.
//

import Foundation
import UIKit
import Kingfisher

final class ListCell: UICollectionViewListCell {
    var heartButtonDidTap: (() -> ())?
    
   private let imageView = UIImageView()
   private let streetLabel = UILabel()
   private let ortLabel = UILabel()
   private let sqmLabel = UILabel()
   private let priceValueLabel = UILabel()
   private let stackView = UIStackView()
   private let heartButton = UIButton()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        streetLabel.text = nil
        ortLabel.text = nil
        sqmLabel.text = nil
        priceValueLabel.text = nil
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 3
        
        streetLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        streetLabel.textColor = .systemBlue
        [ortLabel, sqmLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 14)
        }
       priceValueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let action = UIAction { [weak self] _ in
            self?.heartButtonDidTap?()
        }
        heartButton.addAction(action, for: .touchUpInside)
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView) {
            $0.leading.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalTo(80)
            $0.top.bottom.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(stackView) {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(imageView.snp.trailing).offset(5)
        }
        stackView.addArrangedSubviews([streetLabel, ortLabel, sqmLabel, priceValueLabel])
        
        contentView.addSubview(heartButton) {
            $0.size.equalTo(40)
            $0.trailing.top.equalToSuperview().inset(20)
        }
    }
    
    func setupCell(_ model: ListCellModel) {
        let url = model.image
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "house"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        
        streetLabel.text = [model.street, String(model.house)].joined(separator: " ")
        ortLabel.text = model.ort
        
        let fullString = NSMutableAttributedString(string: "")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(systemName:  "light.panel")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: "\(model.livingArea) sqm "))
        
        let image2Attachment = NSTextAttachment()
        image2Attachment.image = UIImage(systemName: "door.right.hand.open")
       let image2String = NSAttributedString(attachment: image2Attachment)
        fullString.append(image2String)
        fullString.append(NSAttributedString(string: "\(model.numberOfRooms)"))
        sqmLabel.attributedText = fullString
        
        priceValueLabel.text = "\u{20AC} \(String(model.price)) k.k."
        
        let mediumConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        let mediumBoldHeartEmpty = UIImage(systemName: "heart", withConfiguration: mediumConfig)
        let mediumBoldHeartFill = UIImage(systemName: "heart.fill", withConfiguration: mediumConfig)
        heartButton.setImage(model.isFavourite ? mediumBoldHeartFill : mediumBoldHeartEmpty, for: .normal)
        heartButton.tintColor = model.isFavourite ? .red : .systemBlue
    }
}
