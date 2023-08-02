//
//  AdDetailsView.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import Combine
import UIKit

enum AdDetailsViewAction {
    case crossDidTap
    case onBackTap
    case onForwardTap
    case typeTextField(String)
    case numberTextField(String)
    case yearTextField(String)
    case garageTextField(String)
    case livingAreaTextField(String)
    case squareTextField(String)
    case priceTextField(String)
}

final class AdDetailsView: BaseView {
    // MARK: - Subviews
    private let scrollView = AxisScrollView()
    private let pageControl = UIPageControl()
    private let crossButton = UIButton()
    private let addressLabel = UILabel()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let typeStack = UIStackView()
    private let typeLabel = UILabel()
    private let typeTextField = UITextField()
    private let numberStack = UIStackView()
    private let numberLabel = UILabel()
    private let numberTextField = UITextField()
    private let yearStack = UIStackView()
    private let yearLabel = UILabel()
    private let yearTextField = UITextField()
    private let garageStack = UIStackView()
    private let garageLabel = UILabel()
    private let garageTextField = UITextField()
    private let livingAreaStack = UIStackView()
    private let livingAreaLabel = UILabel()
    private let livingAreaTextField = UITextField()
    private let squareStack = UIStackView()
    private let squareLabel = UILabel()
    private let squareTextField = UITextField()
    private let priceStack = UIStackView()
    private let priceLabel = UILabel()
    private let priceTextField = UITextField()
    private let lineView = UIView()
    private let buttonStackView = UIStackView()
    private let backButton = UIButton()
    private let forwardButton = UIButton()
    private let typePicker = UIPickerView(frame: CGRectMake(0, 100, 200, 200))
    private let numberPicker = UIPickerView(frame: CGRectMake(0, 100, 200, 200))
    private let garagePicker = UIPickerView(frame: CGRectMake(0, 100, 200, 200))

    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(self.donePicker)
        )
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(self.donePicker)
        )

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()

    private let typePickerData = ["apartment", "house", "land"]
    private let numberPickerData = ["1", "2", "3", "4", "5"]
    private let garagePickerData = ["Garage", "Free parking", "Municipal parking", "Hourly parking", "No parking"]

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdDetailsViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    @objc
    func donePicker() {
        typeTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        garageTextField.resignFirstResponder()
    }

    private func bindActions() {
        crossButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.crossDidTap)
            })
            .store(in: &cancellables)

        backButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onBackTap)
            })
            .store(in: &cancellables)

        forwardButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onForwardTap)
            })
            .store(in: &cancellables)

        typeTextField.textPublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.typeTextField(text))
            })
            .store(in: &cancellables)

        numberTextField.textPublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.numberTextField(text))
            })
            .store(in: &cancellables)

        garageTextField.textPublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.garageTextField(text))
            })
            .store(in: &cancellables)

        livingAreaTextField.textPublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.livingAreaTextField(text))
            })
            .store(in: &cancellables)

        squareTextField.textPublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.squareTextField(text))
            })
            .store(in: &cancellables)

        priceTextField.textPublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.priceTextField(text))
            })
            .store(in: &cancellables)

        yearTextField.textPublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.yearTextField(text))
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        [typePicker, numberPicker, garagePicker].forEach { picker in
            picker.backgroundColor = .systemGray
            picker.delegate = self
            picker.dataSource = self
        }
        backgroundColor = .white

        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .orange
        addressLabel.text = "Kharkiv Khreschatik 21"
        addressLabel.font = UIFont.systemFont(ofSize: 20)

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .gray

        titleLabel.text = "What about other details?"
        titleLabel.font = UIFont.systemFont(ofSize: 32)
        titleLabel.numberOfLines = 0

        typeLabel.text = " Type of property"
        numberLabel.text = " Number of rooms"
        yearLabel.text = " Year of building"
        garageLabel.text = " Type of parking place"
        livingAreaLabel.text = " Living area"
        squareLabel.text = " Square"
        priceLabel.text = " Price"

        typeTextField.inputAccessoryView = toolBar
        typeTextField.inputView = typePicker
        numberTextField.inputAccessoryView = toolBar
        numberTextField.inputView = numberPicker
        garageTextField.inputAccessoryView = toolBar
        garageTextField.inputView = garagePicker

        [yearTextField, livingAreaTextField, squareTextField, priceTextField].forEach { textField in
            textField.keyboardType = .decimalPad
            textField.addDoneButtonOnKeyboard()
        }

        [
            typeTextField,
            numberTextField,
            yearTextField,
            garageTextField,
            livingAreaTextField,
            squareTextField,
            priceTextField,
        ].forEach { textField in
            textField.delegate = self
            textField.placeholder = "Waiting for your input"
            textField.textAlignment = .center
        }

        stackView.axis = .vertical
        stackView.spacing = 10

        [typeStack, numberStack, yearStack, garageStack, livingAreaStack, squareStack, priceStack].forEach { stack in
            stack.axis = .horizontal
            stack.layer.cornerRadius = 3
            stack.bordered(width: 2, color: .gray)
            stack.distribution = .fillEqually
        }

        lineView.backgroundColor = .gray

        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 16
        buttonStackView.distribution = .fillEqually

        [backButton, forwardButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layer.cornerRadius = 3
            button.bordered(width: 2, color: .gray)
        }
        backButton.setTitle("Back", for: .normal)

        forwardButton.backgroundColor = .orange
        forwardButton.setTitle("Forward", for: .normal)
        forwardButton.alpha = 0.5
        forwardButton.isEnabled = false
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

        scrollView.addSubview(addressLabel) {
            $0.top.equalTo(pageControl.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        scrollView.addSubview(titleLabel) {
            $0.top.equalTo(addressLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        scrollView.addSubview(stackView) {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        [
            typeLabel,
            typeTextField,
            numberLabel,
            numberTextField,
            yearLabel,
            yearTextField,
            garageLabel,
            garageTextField,
            livingAreaLabel,
            livingAreaTextField,
            squareLabel,
            squareTextField,
            priceLabel,
            priceTextField,
        ]
        .forEach { button in button.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        }

        typeStack.addArrangedSubviews([typeLabel, typeTextField])
        numberStack.addArrangedSubviews([numberLabel, numberTextField])
        yearStack.addArrangedSubviews(
            [yearLabel, yearTextField]
        )
        garageStack.addArrangedSubviews([garageLabel, garageTextField])
        livingAreaStack.addArrangedSubviews([livingAreaLabel, livingAreaTextField])
        squareStack.addArrangedSubviews([squareLabel, squareTextField])
        priceStack.addArrangedSubviews([priceLabel, priceTextField])
        stackView
            .addArrangedSubviews([
                typeStack,
                numberStack,
                yearStack,
                garageStack,
                livingAreaStack,
                squareStack,
                priceStack,
            ])
        
        scrollView.addSubview(lineView) {
            $0.top.equalTo(stackView.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }

        scrollView.addSubview(buttonStackView) {
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(500)
        }

        backButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        forwardButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        buttonStackView.addArrangedSubviews([backButton, forwardButton])
    }

    func setupView(_ adDetails: AdCreatingRequestModel) {
        let address = [adDetails.ort ?? "", adDetails.street ?? "", String(adDetails.house ?? 0) ].joined(separator: " ")
        addressLabel.text = address
        var isRequestModelFilled = false
        if adDetails.house != nil,
           adDetails.price != nil,
           adDetails.ort != nil,
           adDetails.street != nil,
           adDetails.square != nil
        {
            isRequestModelFilled = true
        } else {
            isRequestModelFilled = false
        }
        forwardButton.alpha = isRequestModelFilled ? 1 : 0.5
        forwardButton.isEnabled = isRequestModelFilled ? true : false
    }
}

// MARK: - extension
extension AdDetailsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}

// MARK: - extension
extension AdDetailsView: UITextViewDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        switch textField {
        case yearTextField:
            let maxLength = 4
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
            
        case livingAreaTextField, squareTextField:
            let maxLength = 5
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
            
        case priceTextField:
            let maxLength = 8
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength

        default:
            let maxLength = 0
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
    }
}

// MARK: - extension
extension AdDetailsView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case typePicker:
            return typePickerData.count
        case numberPicker:
            return numberPickerData.count
        case garagePicker:
            return garagePickerData.count
        default:
            return garagePickerData.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case typePicker:
            return typePickerData[row]
        case numberPicker:
            return numberPickerData[row]
        case garagePicker:
            return garagePickerData[row]
        default:
            return garagePickerData[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case typePicker:
            return typeTextField.text = typePickerData[row]
        case numberPicker:
            return numberTextField.text = numberPickerData[row]
        case garagePicker:
            return garageTextField.text = garagePickerData[row]
        default:
            break
        }
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct AdDetailsPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(AdDetailsView())
        }
    }
#endif
