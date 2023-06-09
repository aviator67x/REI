//
//  OrtCell.swift
//  RomaMVVM
//
//  Created by User on 09.06.2023.
//

import Foundation
import UIKit
import Combine

final class OrtCell: UICollectionViewCell {
    private let placemarkView = UIImageView()
    private let textField = UITextField()
    
    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
       
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = []
    }

    private func setupUI() {
        placemarkView.image = UIImage(systemName: "mappin.and.ellipse")
        placemarkView.tintColor = .black
        textField.placeholder = "Ort"
    }

    private func setupLayout() {
        contentView.addSubview(placemarkView) {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview().offset(8)
            $0.size.equalTo(25)
        }

        contentView.addSubview(textField) {
            $0.leading.equalTo(placemarkView.snp.trailing).offset(10)
            $0.centerY.equalTo(placemarkView.snp.centerY).offset(5)
        }
    }

    func setupCell(with model: OrtCellModel) {
        textField.textPublisher
            .dropFirst()
            .assignWeakly(to: \.value, on: model.ort)
            .store(in: &cancellables)
    }
}
