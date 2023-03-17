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
    var nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.text = "Section Header"
        nameLabel.textColor = .red
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .yellow
        addSubview(nameLabel) {
            $0.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
