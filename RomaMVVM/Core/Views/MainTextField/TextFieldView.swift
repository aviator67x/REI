////
////  TextFieldView.swift
////  Interngram-Bravo
////
////  Created by Georhii Kasilov on 30.10.2022.
////
//
//import UIKit
//
//protocol TextFieldButtonDelegate: AnyObject {
//    func returnButtonDidTap()
//}
//
//final class TextFieldView: UIStackView {
//    // MARK: - Internal properties
//    weak var buttonDelegate: TextFieldButtonDelegate?
//
//    // MARK: - Private properties
//    private let type: TextFieldType
//    private var withHeaderTitle: Bool = false
//
//    // MARK: - Subviews
//    private lazy var headerTitle: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.text = type.headerTitle
//        label.font = UIFont(name: "SF-Pro-Text-Bold", size: 15)
//        label.textColor = .black
//        return label
//    }()
//
//    lazy var textField: TextField = {
//        let textField = TextField(type: type)
//        textField.buttonDelegate = self
//        textField.stateDidChange = { [weak self] state in
//            if case let .invalid(errorMessage) = state {
//                self?.errorMessageLable.text = errorMessage
//            } else {
//                self?.errorMessageLable.text = nil
//            }
//            self?.errorMessageLable.isHidden = !state.isErrorVisible
//            UIView.animate(withDuration: 0) {
//                self?.layoutIfNeeded()
//            }
//        }
//        return textField
//    }()
//
//    lazy var errorMessageLable: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textColor = UIColor(named: "error")
//        label.numberOfLines = 0
//        label.isHidden = true
//        return label
//    }()
//
//    // MARK: - Init
//    init(type: TextFieldType) {
//        self.type = type
//        super.init(frame: .zero)
//        setupView()
//    }
//
//    init(type: TextFieldType, withHeaderTitle: Bool) {
//        self.type = type
//        self.withHeaderTitle = withHeaderTitle
//        super.init(frame: .zero)
//        setupView()
//    }
//
//    @available(*, unavailable)
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - TextFieldDelegate
//extension TextFieldView: TextFieldDelegate {
//    func returnButtonDidTap() {
//        buttonDelegate?.returnButtonDidTap()
//    }
//}
//
//// MARK: - Internal extension
//extension TextFieldView {
//    func changeSsUserInteractionEnabled(to state: Bool) {
//        textField.isUserInteractionEnabled = state
//    }
//
//    func showErrorMessageForPassword() {
//        textField.showErrorMessageForPassword()
//    }
//
//    func showEmptyErrorMessage() {
//        textField.showEmptyErrorMessageForPassword()
//    }
//
//    func showAccountNotFoundError() {
//        textField.showAccountNotFoundError()
//    }
//
//    func textIsEmpty() -> Bool? {
//        return textField.text?.isEmpty
//    }
//
//    func returnTextFromTextField() -> String? {
//        return textField.text
//    }
//
//    func changeTextFieldState(state: TextField.State) {
//        textField.fieldState = state
//    }
//
//    func textIsValid() -> Bool {
//        return textField.fieldState.isValid
//    }
//    
//    func removeRightView() {
//        textField.rightView = nil
//    }
//
//    func cleanUpTextField() {
//        textField.text = ""
//    }
//
//    func textFieldBecomeFirstResponder() {
//        textField.becomeFirstResponder()
//    }
//}
//
//// MARK: - Private extension
//private extension TextFieldView {
//    private func setupView() {
//        defer {
//            axis = .vertical
//            spacing = 8
//            addArrangedSubview(textField) {
//                $0.height.equalTo(44)
//            }
//            addArrangedSubview(errorMessageLable)
//        }
//        guard withHeaderTitle else {
//            return
//        }
//        addArrangedSubview(headerTitle)
//    }
//}
