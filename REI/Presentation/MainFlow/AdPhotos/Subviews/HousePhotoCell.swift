//
//  HousePhotoCell.swift
//  REI
//
//  Created by User on 29.05.2023.
//

import Foundation
import UIKit
import Combine

enum HousePhotoCellAction {
    case crossDidTap
}

final class HousePhotoCell: UICollectionViewCell {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<HousePhotoCellAction, Never>()

    var cancellables = Set<AnyCancellable>()

    let imageView = UIImageView()
    let crossButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBinding() {
        crossButton.tapPublisher
            .sinkWeakly(self, receiveValue: { _, _ in
                self.actionSubject.send(.crossDidTap)
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply.circle",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .white
    }

    private func setupLayout() {
        contentView.addSubview(imageView) {
            $0.edges.equalToSuperview()
        }

        contentView.addSubview(crossButton) {
            $0.trailing.top.equalToSuperview().inset(10)
        }
    }

    func setupCell(_ image: Data) {
        imageView.image = UIImage(data: image)
    }
}
