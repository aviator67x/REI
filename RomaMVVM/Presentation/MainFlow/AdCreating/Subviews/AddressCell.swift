//
//  AddressCell.swift
//  RomaMVVM
//
//  Created by User on 16.05.2023.
//

import Combine
import Foundation
import UIKit

enum AddressCellAction {
    case ort(String)
    case street(String)
    case house(String)
}

final class AddressCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let ortLabel = UILabel()
    private let stackView = UIStackView()
    private let ortTextField = UITextField()
    private let ortStackView = UIStackView()
    private let streetLabel = UILabel()
    private let streetTextField = UITextField()
    private let streetStackView = UIStackView()
    private let houseLabel = UILabel()
    private let houseTextField = UITextField()
    private let houseStackView = UIStackView()
    private let validationView = UIView()
    private let validationLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    private var isAddressValid = true

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AddressCellAction, Never>()

    lazy var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
        setupBinding()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(endEding))
        addGestureRecognizer(recognizer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func endEding() {
        resignFirstResponder()
    }

    private func setupUI() {
        titleLabel.text = "What is your address?"
        titleLabel.font = UIFont.systemFont(ofSize: 32)

        ortLabel.text = "City"
        streetLabel.text = "Street"
        houseLabel.text = "House"

        [ortStackView, streetStackView, houseStackView].forEach { stackView in
            stackView.axis = .vertical
            stackView.spacing = 10
        }

        [ortLabel, streetLabel, houseLabel, validationLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 20)
        }

        validationLabel.numberOfLines = 0

        [ortTextField, streetTextField, houseTextField].forEach { textField in
            textField.bordered(width: 2, color: .gray)
            textField.textAlignment = .left
            textField.contentVerticalAlignment = .center
            textField.font = UIFont.systemFont(ofSize: 24)
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
            textField.leftView = paddingView
            textField.leftViewMode = .always
            textField.delegate = self
        }

        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually

        validationView.backgroundColor = .red
    }

    private func setupLayout() {
        contentView.addSubview(titleLabel) {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        contentView.addSubview(ortStackView) {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        [ortTextField, streetTextField, houseTextField].forEach { textField in
            textField.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }

        ortStackView.addArrangedSubviews([ortLabel, ortTextField])

        contentView.addSubview(stackView) {
            $0.top.equalTo(ortStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        stackView.addArrangedSubviews([streetStackView, houseStackView])

        streetStackView.addArrangedSubviews([streetLabel, streetTextField])

        houseStackView.addArrangedSubviews([houseLabel, houseTextField])

        addSubview(validationView) {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        validationView.addSubview(checkmarkImageView) {
            $0.top.leading.equalToSuperview().offset(20)
            $0.size.equalTo(30)
        }

        validationView.addSubview(validationLabel) {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(checkmarkImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
    }

    private func setupBinding() {
        ortTextField.publisher(for: \.text)
            .sinkWeakly(self, receiveValue: { (self, text) in
                guard let text = text else {
                    return
                }
                self.actionSubject.send(.ort(text))
            })
            .store(in: &cancellables)

        streetTextField.publisher(for: \.text)
            .sinkWeakly(self, receiveValue: { (self, text) in
                guard let text = text else {
                    return
                }
                self.actionSubject.send(.street(text))
            })
            .store(in: &cancellables)

        houseTextField.publisher(for: \.text)
            .sinkWeakly(self, receiveValue: { (self, text) in
                guard let text = text else {
                    return
                }
                self.actionSubject.send(.house(text))
            })
            .store(in: &cancellables)
    }

    func setupCell(with model: AddressCellModel) {
        if model.ort == nil || model.street == nil || model.house == nil {
            validationLabel.text = ""
            checkmarkImageView.isHidden = true
        } else {
            checkmarkImageView.isHidden = false
            isAddressValid = model.isValid
            guard let ort = model.ort,
                  let street = model.street,
                  let house = model.house
            else {
                return
            }
            ortTextField.text = ort
            streetTextField.text = street
            houseTextField.text = house

            validationLabel
                .text = isAddressValid ? [ort, street, house].joined(separator: " ") :
                "This address doesn't exist"

            let checkmarkImage = UIImage(systemName: "checkmark.circle")
            let stopImage = UIImage(systemName: "exclamationmark.octagon")
            checkmarkImageView.image = isAddressValid ? checkmarkImage : stopImage
            checkmarkImageView.tintColor = isAddressValid ? .green : .red
        }
    }
}

// MARK: - extension
extension AddressCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.endEditing(true)
           return false
       }
}
