//
//  ListCell.swift
//  RomaMVVM
//
//  Created by User on 21.04.2023.
//

import Foundation
import UIKit
import Kingfisher

final class ListCell: UICollectionViewListCell {
    static let reusedidentifier = String(describing: ListCell.self)
    
    let imageView = UIImageView()
    let streetLabel = UILabel()
    let ortLabel = UILabel()
    let sqmLabel = UILabel()
    let priceValueLabel = UILabel()
    let stackView = UIStackView()
    let heartButton = UIButton()
    
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
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView) {
            $0.leading.equalToSuperview()
            $0.height.equalTo(300)
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
        imageView.kf.setImage(with: model.image, placeholder: UIImage(systemName: "house.lodge.circle"))
        streetLabel.text = model.street
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
    }
}
