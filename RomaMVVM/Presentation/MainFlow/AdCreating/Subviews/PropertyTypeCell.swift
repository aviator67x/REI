//
//  TypeCell.swift
//  RomaMVVM
//
//  Created by User on 16.05.2023.
//

import Combine
import Foundation
import UIKit

enum PropertCellAction {
    case onTypeTap
    case onNumberTap
    case onYearTap
    case onGarageTap
    case onDistanceTap
}

final class PropertyTypeCell: UICollectionViewCell {
    private let addressLabel = UILabel()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let typeButton = UIButton()
    private let numberButton = UIButton()
    private let yearButton = UIButton()
    private let garageButton = UIButton()
    private let distanceButton = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<PropertCellAction, Never>()

    lazy var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
        setupBinding()
        setupCell(with: .init())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addressLabel.text = "Kharkiv Khreschatik 21"
        addressLabel.font = UIFont.systemFont(ofSize: 20)

        titleLabel.text = "What about other details?"
        titleLabel.font = UIFont.systemFont(ofSize: 32)
        titleLabel.numberOfLines = 0

        typeButton.setTitle("Type of property", for: .normal)
        numberButton.setTitle("Number of rooms", for: .normal)
        garageButton.setTitle("Type of parking", for: .normal)
        yearButton.setTitle("Year of construction", for: .normal)
        distanceButton.setTitle("Distance from desired place", for: .normal)
        [typeButton, numberButton, yearButton, garageButton, distanceButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .left
            button.layer.cornerRadius = 3
            button.bordered(width: 2, color: .gray)
        }

        stackView.axis = .vertical
        stackView.spacing = 10
    }

    private func setupLayout() {
        contentView.addSubview(addressLabel) {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        contentView.addSubview(titleLabel) {
            $0.top.equalTo(addressLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        contentView.addSubview(stackView) {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
//            $0.bottom.equalToSuperview()
        }

        [typeButton, numberButton, yearButton, garageButton, distanceButton]
            .forEach { button in button.snp.makeConstraints {
                $0.height.equalTo(50)
            }
            }
        stackView.addArrangedSubviews([typeButton, numberButton, yearButton, garageButton, distanceButton])
    }

    private func setupBinding() {
        typeButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onTypeTap)
            })
            .store(in: &cancellables)
        
        numberButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onNumberTap)
            })
            .store(in: &cancellables)
        
        yearButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onYearTap)
            })
            .store(in: &cancellables)
        
        garageButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onGarageTap)
            })
            .store(in: &cancellables)
        
        distanceButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onDistanceTap)
            })
            .store(in: &cancellables)
    }

    func setupCell(with model: AdCreatingRequestModel) {
        guard let ort = model.ort,
              let street = model.street
        else {
            return
        }
        addressLabel.text = "Kharkiv Khreschatik 21" // [ort, street].joined(separator: " ")
    }
}
