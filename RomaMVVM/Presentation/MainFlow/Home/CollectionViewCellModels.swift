//
//  CellModels.swift
//  CollectionComposition
//
//  Created by User on 08.02.2023.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    let photo = UIImageView(image: UIImage(named: "girl"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        photo.backgroundColor = .blue
        contentView.addSubview(photo) {
            $0.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SectionHeaderView: UICollectionReusableView {
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
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
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
    
    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        
        photo.layer.cornerRadius = 60
        photo.clipsToBounds = true
        photo.image = UIImage(named: "girl")
        
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.text = "NameLabel"
        
        emailLabel.text = "EmailLabel"
    }
}

final class SectionFooterView: UICollectionReusableView {
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.text = "Section Footer"
        nameLabel.textColor = .red
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .white
        addSubview(nameLabel) {
            $0.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class BadgeView: UICollectionReusableView {
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.text = "Badge"
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .green
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SectionBackground: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 8
        backgroundColor = UIColor(white: 0.85, alpha: 1)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
