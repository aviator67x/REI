//
//  AdAdressView.swift
//  RomaMVVM
//
//  Created by User on 19.05.2023.
//

import Combine
import UIKit

enum AdAddressViewAction {
    case crossDidTap
    case forwardDidTap
    case ort(String)
    case street(String)
    case house(String)
}

final class AdAddressView: BaseView {
    // MARK: - Subviews
    private let scrollView = AxisScrollView()
    private let pageControl = UIPageControl()
    private let crossButton = UIButton()
    private let titleLabel = UILabel()
    private let ortLabel = UILabel()
    private let ortTextField = UITextField()
    private let ortMessageLabel = UILabel()
    private let ortStackView = UIStackView()
    private let streetLabel = UILabel()
    private let streetTextField = UITextField()
    private let streetMessageLabel = UILabel()
    private let streetView = UIView()
    private let houseLabel = UILabel()
    private let houseTextField = UITextField()
    private let houseMessageLabel = UILabel()
    private let houseView = UIView()
    private let validationView = UIView()
    private let validationLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    private let lineView = UIView()
    private let stackView = UIStackView()
    private let forwardButton = UIButton()

    private var isAddressValid = true

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdAddressViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(recognizer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onTap() {
        endEditing(true)
        resignFirstResponder()
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
        forwardButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.forwardDidTap)
            })
            .store(in: &cancellables)

        crossButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.crossDidTap)
            })
            .store(in: &cancellables)

        ortTextField.textPublisher
            .sinkWeakly(self, receiveValue: { (self, text) in
                guard let text = text else {
                    return
                }
                self.actionSubject.send(.ort(text))
            })
            .store(in: &cancellables)

        streetTextField.textPublisher
            .sinkWeakly(self, receiveValue: { (self, text) in
                guard let text = text else {
                    return
                }
                self.actionSubject.send(.street(text))
            })
            .store(in: &cancellables)

        houseTextField.textPublisher
            .sinkWeakly(self, receiveValue: { (self, text) in
                guard let text = text else {
                    return
                }
                self.actionSubject.send(.house(text))
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        
        
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceHorizontal = false

        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .orange

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .gray

        titleLabel.text = "What is your address?"
        titleLabel.font = UIFont.systemFont(ofSize: 32)

        ortLabel.text = "City"
        ortMessageLabel.text = "Please, enter your city"
        streetLabel.text = "Street"
        streetMessageLabel.text = "Please, enter your street"
        houseLabel.text = "House"
        houseMessageLabel.text = "Please, enter your house number"

        [ortLabel, streetLabel, houseLabel, validationLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 20)
            label.numberOfLines = 0
        }

        [ortMessageLabel, streetMessageLabel, houseMessageLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
        }

        [ortMessageLabel, streetMessageLabel, houseMessageLabel].forEach { label in
            label.textColor = .red
        }

        ortStackView.axis = .vertical
        ortStackView.spacing = 10

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

        lineView.backgroundColor = .gray

        forwardButton.backgroundColor = .orange
        forwardButton.setTitle("Forward", for: .normal)
        forwardButton.setTitleColor(.black, for: .normal)
        forwardButton.titleLabel?.textAlignment = .center
        forwardButton.layer.cornerRadius = 3
        forwardButton.bordered(width: 2, color: .gray)
        forwardButton.alpha = 0.5
        forwardButton.isEnabled = false
        
        ortTextField.text = ""
        streetTextField.text = ""
        houseTextField.text = ""
    }

    private func setupLayout() {
        addSubview(scrollView) {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(pageControl) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(20)
            $0.width.equalTo(200)
        }
        
        scrollView.addSubview(crossButton) {
            $0.centerY.equalTo(pageControl.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(40)
        }

        scrollView.addSubview(titleLabel) {
            $0.top.equalTo(pageControl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        scrollView.addSubview(ortStackView) {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
        }

        [ortTextField, streetTextField, houseTextField].forEach { textField in
            textField.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }

        ortStackView.addArrangedSubviews([ortLabel, ortTextField, ortMessageLabel])

        scrollView.addSubview(stackView) {
            $0.top.equalTo(ortStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(140)
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
        }
        stackView.addArrangedSubviews([streetView, houseView])

        streetView.addSubview(streetLabel) {
            $0.top.leading.trailing.equalToSuperview()
        }

        streetView.addSubview(streetTextField) {
            $0.top.equalTo(streetLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        streetView.addSubview(streetMessageLabel) {
            $0.top.equalTo(streetTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        houseView.addSubview(houseLabel) {
            $0.top.leading.trailing.equalToSuperview()
        }

        houseView.addSubview(houseTextField) {
            $0.top.equalTo(houseLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        houseView.addSubview(houseMessageLabel) {
            $0.top.equalTo(houseTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.addSubview(validationView) {
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
        
        scrollView.addSubview(lineView) {
            $0.top.equalTo(stackView.snp.bottom).offset(260)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }

        scrollView.addSubview(forwardButton) {
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(500)
        }
    }
    
    func setupView(with initialValue: AdCreatingRequestModel) {
        guard let ort = initialValue.ort,
              let street = initialValue.street,
              let house = initialValue.house  else {
            return
        }
                    ortTextField.text = ort
                    streetTextField.text = street
                    houseTextField.text = String(describing: house)
    }

    func setupView(with model: AddressModel) {
        ortMessageLabel.isHidden = model.isOrtValid
        streetMessageLabel.isHidden = model.isStreetValid
        houseMessageLabel.isHidden = model.isHouseValid

        guard let ort = model.ort,
              let street = model.street,
              let house = model.house else {
            forwardButton.isEnabled = true
            return
        }

        if ort.count < 3,
           street.count < 3,
           house.count < 1
        {
            validationView.isHidden = true
        } else {
            validationView.isHidden = false
            isAddressValid = model.isValid

            validationLabel
                .text = isAddressValid ? [ort, street, house].joined(separator: " ") :
                "This address doesn't exist"

            let checkmarkImage = UIImage(systemName: "checkmark.circle")
            let stopImage = UIImage(systemName: "exclamationmark.octagon")
            checkmarkImageView.image = isAddressValid ? checkmarkImage : stopImage
            checkmarkImageView.tintColor = isAddressValid ? .green : .red
            
            forwardButton.alpha = isAddressValid ? 1 : 0.5
            forwardButton.isEnabled = isAddressValid ? true : false
        }
    }
}

// MARK: - extension
extension AdAddressView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct AdAdressPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(AdAddressView())
        }
    }
#endif
