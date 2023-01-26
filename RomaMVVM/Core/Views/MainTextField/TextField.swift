//
//  TextField.swift
//  Hydrostasis
//
//  Created by Gorilka on 3/10/19.
//  Copyright © 2019 Hydrostasis Inc. All rights reserved.
//

import UIKit
//
//protocol TextFieldDelegate: AnyObject {
//    func returnButtonDidTap()
//}
//
//protocol TextFieldDidChangeDelegate: AnyObject {
//    func textFieldDidChange()
//}
//
final class TextField: UITextField {
    // MARK: - TextField states
    enum State: Equatable {
        case valid
        case invalid(errorMessage: String?)
    }
//    
//    // MARK: - Internal properties
//    weak var buttonDelegate: TextFieldDelegate?
//    weak var textFieldDidChangeDelegate: TextFieldDidChangeDelegate?
//    var isEditable: Bool = true
//    var onNonEditableHandler: (() -> Void)?
//    var becomeFirstResponderHandler: (() -> Void)?
//    var resignFirstResponderHandler: (() -> Void)?
//    var textFieldShouldReturn: ((_ textField: UITextField) -> Bool)?
//    var stateDidChange: ((_ state: State) -> Void)?
//    var didChangeSelection: ((_ text: String?) -> Void)?
//    var textDidChange: ((_ text: String?) -> Void)?
//    var fieldState: State = .invalid(errorMessage: nil) {
//        didSet {
//            stateDidChange?(fieldState)
//            updateColors()
//            updateRightImagesToGreenCheckmark()
//        }
//    }
//    
    // MARK: - Private properties
    private let type: TextFieldType
//    
//    // MARK: - Overrided
//    @discardableResult
//    override func becomeFirstResponder() -> Bool {
//        let result = super.becomeFirstResponder()
//        
//        becomeFirstResponderHandler?()
//        
//        return result
//    }
//    
//    @discardableResult
//    override func resignFirstResponder() -> Bool {
//        let result = super.resignFirstResponder()
//        resignFirstResponderHandler?()
//        return result
//    }
//    
    // MARK: - Public methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insets: UIEdgeInsets = (type == .phone || type == .phoneForPasswordRecovery) ? [\.left: 84.5] : [\.left: 14]
        return bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if (type == .phone || type == .phoneForPasswordRecovery) {
            return bounds.inset(by: [\.left: 84.5])
        } else {
            return bounds.inset(by: [\.left: 14])
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if (type == .phone || type == .phoneForPasswordRecovery) {
            return bounds.inset(by: [\.left: 84.5])
        } else {
            return bounds.inset(by: [\.left: 14, \.right: 32])
        }
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.inset(by: [\.right: 14])
    }
    
    init(type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        setTextField()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    @objc
    private func onRightImageViewTapped() {
        switch type {
        case .password, .confirmPassword, .passwordWithoutVerification:
            isSecureTextEntry.toggle()
            rightImageView.image = isSecureTextEntry ? type.rightImage : UIImage(systemName: "eye")
            layoutIfNeeded()
        default: break
        }
    }
    
    // MARK: - Views
    fileprivate lazy var rightImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 12))
        imageView.image = type.rightImage
        imageView.tintColor = UIColor.systemGray2
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onRightImageViewTapped)
        )
        imageView.addGestureRecognizer(gestureRecognizer)
        
        return imageView
    }()
    
    fileprivate lazy var leftCodeView: UIView = {
        let label = UILabel {
            $0.font = UIFont(name: "sfProTextRegular", size: 12)
            $0.text = "UA +380"
            $0.textColor = UIColor(named: "secondaryTextColor")
        }
        let paleView = UIView { $0.backgroundColor = UIColor(named: "borderTextField") }
        
        return UIView { view in
            view.addSubview(label) {
                $0.center.equalToSuperview()
                $0.left.equalTo(view.snp.left).inset(14)
            }
            
            view.addSubview(paleView) {
                $0.top.bottom.equalToSuperview()
                $0.left.equalTo(label.snp.right).offset(8)
                $0.width.equalTo(1)
                $0.height.equalTo(28)
            }
        }
    }()
}
//
//extension TextField {
//    func performValidation(with validators: [Validable]) -> Bool {
//        var shouldRemoveAdditionalCharacters: Bool = false
//        switch type {
//        case .phone, .phoneForPasswordRecovery: shouldRemoveAdditionalCharacters = true
//        default: break
//        }
//        return validators.first(where: { !$0.isValid(text, shouldRemoveAdditionalCharacters: shouldRemoveAdditionalCharacters) }) == nil
//    }
//    
//    func validateText() {
//        if let text = text, text.isEmpty {
//            return fieldState = .invalid(errorMessage: nil)
//        }
//        if !performValidation(with: type.symbolCountValidator) {
//            if let text = text, text.count > 9 {
//                fieldState = .invalid(errorMessage: type.maxSymbolsErrorMessage)
//            } else {
//                fieldState = .invalid(errorMessage: type.minSymbolsErrorMessage)
//            }
//        } else if !performValidation(with: type.regExValidators) {
//            fieldState = .invalid(errorMessage: type.regExtErrorMessage)
//        } else {
//            fieldState = .valid
//        }
//    }
//    
//    func showErrorMessageForPassword() {
//        if type == .passwordWithoutVerification {
//            fieldState = .invalid(errorMessage: type.regExtErrorMessage)
//            updateColors()
//        }
//    }
//    
//    func showEmptyErrorMessageForPassword() {
//        fieldState = .invalid(errorMessage: L10n.TextField.fieldIsRequired)
//        updateColors()
//    }
//    
//    func showAccountNotFoundError() {
//        fieldState = .invalid(errorMessage: L10n.TextField.accountDoesNotExist)
//        updateColors()
//    }
//}
//
//// MARK: - extension UITextFieldDelegate
//
//extension TextField: UITextFieldDelegate {
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        validateText()
//        didChangeSelection?(text)
//        textFieldDidChangeDelegate?.textFieldDidChange()
//        hideRightImageViewWhenFieldIsEmpty(textField)
//    }
//    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if !isEditable {
//            onNonEditableHandler?()
//            return false
//        }
//        return true
//    }
//    
//    func textField(
//        _ textField: UITextField,
//        shouldChangeCharactersIn range: NSRange,
//        replacementString string: String
//    ) -> Bool {
//        guard isEditable else { return false }
//        guard let oldText = textField.text else { return true }
//        
//        let newLength = oldText.count + string.count - range.length
//        if (range.location == 0 && string == " ") || (range.location == 0 && string == ".") {
//            return false
//        }
//        if string == " " && type != .fullName && type != .city {
//            return false
//        }
//        
//        if type.rightImage != nil {
//            addRightImageToTextField()
//        }
//        
//        switch type {
//        case .phone, .phoneForPasswordRecovery: return newLength <= 9
//        case .nickName: return newLength <= 21
//        case .fullName: return newLength <= 36
//        case .city: return newLength <= 51
//        case .password, .confirmPassword: return newLength <= 24
//        default: break
//        }
//        return newLength <= 35
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        ((buttonDelegate?.returnButtonDidTap()) != nil)
//    }
//}
//
//// MARK: - Set Views
extension TextField {
//    func updateColors() {
//        if fieldState.isErrorVisible {
//            self.animateBorderColor(toValue: UIColor.red, duration: 0.3)
//        } else {
//            self.animateBorderColor(toValue: Asset.Colors.borderTextField.color, duration: 0.3)
//        }
//        
//        if let leftImageView = leftView as? UIImageView {
//            leftImageView.tintColor = fieldState.isErrorVisible ? Asset.Colors.errorRed.color : Asset.Colors.borderTextField.color
//        }
//        
//        if let rightImageView = rightView as? UIImageView {
//            if type != .password, type != .confirmPassword, type != .passwordWithoutVerification {
//                rightImageView.tintColor = !fieldState.isValid ? .red : .systemGray2
//            }
//        }
//    }
//    
//    func updateRightImagesToGreenCheckmark() {
//        if type == .fullName || type == .nickName || type == .phoneForPasswordRecovery || type == .emailForPasswordRecovery {
//            rightImageView.image = fieldState.isValid ? UIImage(systemName: "checkmark.circle") : type.rightImage
//            rightImageView.tintColor = !fieldState.isValid ? Asset.Colors.errorRed.color : Asset.Colors.successGreen.color
//        }
//    }
//    
    func setTextField() {
        backgroundColor = UIColor(named: "textFieldsBackground")
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "borderTextField")?.cgColor
        borderStyle = .none
//        delegate = self
        keyboardType = type.keyboardType
        attributedPlaceholder = type.placeholder
        isSecureTextEntry = type.needsSecureTextEntry
        autocorrectionType = .no
        font = UIFont(name: "SF-Pro-Text-Regular", size: 12)
        textColor = UIColor.black
        smartQuotesType = .no
        
        if type == .password ||
            type == .confirmPassword ||
            type == .passwordWithoutVerification {
            addRightImageToTextField()
        }
        
        if type == .phone || type == .phoneForPasswordRecovery {
            addLeftImageToTextField()
        }
    }
    
    func addRightImageToTextField() {
        rightViewMode = .always
        rightView = rightImageView
    }
    
    func addLeftImageToTextField() {
        leftViewMode = .always
        leftView = leftCodeView
    }
}
//
//extension TextField.State {
//    var isValid: Bool { self == .valid }
//    var isErrorVisible: Bool {
//        if case let .invalid(errorMessage) = self,
//           errorMessage != nil { return true }
//        return false
//    }
//}
//
//// MARK: - Private extension
//private extension TextField {
//    func hideRightImageViewWhenFieldIsEmpty(_ textField: UITextField) {
//        switch type {
//        case .city:
//            rightImageView.isHidden = textField.text.isNilOrEmpty
//        default:
//            break
//        }
//    }
//}
