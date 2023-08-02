//
//  HouseImagesCellModel.swift
//  REI
//
//  Created by User on 07.06.2023.
//

import Foundation
import UIKit

final class HouseImagesCell: UICollectionViewCell {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }

    private func setupLayout() {
        contentView.addSubview(imageView) {
            $0.edges.equalToSuperview()
        }
    }

    func setupCell(_ url: URL) {
        imageView.kf.setImage(with: url)
    }
}
