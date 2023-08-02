//
//  SignUpView.swift
//  REI
//
//  Created by user on 12.02.2023.
//

import Combine
import SnapKit
import UIKit

enum SignUpViewAction {
    case nameDidChange(String)
    case emailDidChange(String)
    case passwordDidChange(String)
    case confirmPasswordDidChange(String)
    case signUpDidTap
    case crossDidTap
}

final class SignUpView: BaseView {
    // MARK: - Subviews
    private let contentView = UIView()
    private let crossButton = UIButton()
    private let logoView = UIImageView()
    private let scrollView = AxisScrollView()
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let nameErrorMessageLabel = UILabel()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailErrorMessageLabel = UILabel()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordErrorMessageLabel = UILabel()
    private let confirmPasswordLabel = UILabel()
    private let confirmPasswordTextField = UITextField()
    private let confirmPasswordErrorMessageLabel = UILabel()
    private let signUpButton = BaseButton(buttonState: .signUp)
    private let passwordRightImage = UIButton()
    private let confirmPasswordRightImage = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SignUpViewAction, Never>()

    private var isPasswordVisible = false
    private var isConfirmPasswordVisible = false

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    @objc
    private func hideKeyboardByTappingOutside() {
        endEditing(true)
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTappingOutside))
        addGestureRecognizer(tap)
    }

    func setSignUpButton(enabled: Bool) {
        signUpButton.isEnabled = enabled
        signUpButton.alpha = enabled ? 1 : 0.5
    }

    private func bindActions() {
        nameTextField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] in actionSubject.send(.nameDidChange($0)) }
            .store(in: &cancellables)

        emailTextField.textPublisher
            .replaceNil(with: "")
            .dropFirst(3)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [unowned self] in actionSubject.send(.emailDidChange($0)) }
            .store(in: &cancellables)

        passwordTextField.textPublisher
            .replaceNil(with: "")
            .dropFirst(3)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [unowned self] in actionSubject.send(.passwordDidChange($0)) }
            .store(in: &cancellables)

        confirmPasswordTextField.textPublisher
            .replaceNil(with: "")
            .dropFirst(3)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [unowned self] in actionSubject.send(.confirmPasswordDidChange($0)) }
            .store(in: &cancellables)

        signUpButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.signUpDidTap) }
            .store(in: &cancellables)

        passwordRightImage.tapPublisher
            .sink { [unowned self] in
                self.isPasswordVisible.toggle()
                handlePasswordTextField()
            }
            .store(in: &cancellables)

        confirmPasswordRightImage.tapPublisher
            .sink { [unowned self] in
                self.isConfirmPasswordVisible.toggle()
                handleConfirmPasswordTextField()
            }
            .store(in: &cancellables)

        crossButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.crossDidTap)
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .systemGray

        logoView.image = UIImage(named: "newLogo")
        logoView.tintColor = .orange

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .white

        nameTextField.placeholder = Localization.name
        emailTextField.placeholder = Localization.email

        passwordTextField.placeholder = Localization.password
        let eyeSlashImage = UIImage(systemName: "eye.slash")
        [passwordRightImage, confirmPasswordRightImage].forEach { button in
            button.setImage(eyeSlashImage, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(
                x: CGFloat(passwordTextField.frame.size.width - 25),
                y: CGFloat(5),
                width: CGFloat(25),
                height: CGFloat(25)
            )
            button.tintColor = .lightGray
        }
        passwordTextField.rightView = passwordRightImage
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true

        confirmPasswordTextField.placeholder = Localization.confirmPassword
        confirmPasswordTextField.rightView = confirmPasswordRightImage
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.isSecureTextEntry = true

        [nameLabel, emailLabel, passwordLabel, confirmPasswordLabel].forEach { label in
            label.font = UIFont(name: "SFProText-Regular", size: 14)
            label.textColor = .white
        }
        nameLabel.text = "Name"
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
        confirmPasswordLabel.text = "Confirm password"

        signUpButton.backgroundColor = .orange

        [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.layer.cornerRadius = 3
        }

        [nameErrorMessageLabel, emailErrorMessageLabel, passwordErrorMessageLabel].forEach { item in
            item.font = FontFamily.SFProText.regular.font(size: 14)
            item.textColor = UIColor(named: "error")
            item.numberOfLines = 0
        }
    }

    private func setupLayout() {
        scrollView.contentView.addSubview(logoView) {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(150)
        }

        let stack = UIStackView()
        stack.setup(axis: .vertical, alignment: .fill, distribution: .fill, spacing: Constants.textFieldSpacing)
        stack.addSpacer(200)
        stack.addArranged(nameLabel)
        stack.addArranged(nameTextField, size: Constants.textFieldHeight)
        stack.addArranged(nameErrorMessageLabel)
        stack.addArranged(emailLabel)
        stack.addArranged(emailTextField, size: Constants.textFieldHeight)
        stack.addArranged(emailErrorMessageLabel)
        stack.addArranged(passwordLabel)
        stack.addArranged(passwordTextField, size: Constants.textFieldHeight)
        stack.addArranged(passwordErrorMessageLabel)
        stack.addArranged(confirmPasswordLabel)
        stack.addArranged(confirmPasswordTextField, size: Constants.textFieldHeight)
        stack.addSpacer(100)
        stack.addArranged(signUpButton, size: Constants.doneButtonHeight)

        addSubview(scrollView, withEdgeInsets: .zero, safeArea: true, bottomToKeyboard: true)
        scrollView.contentView.addSubview(stack, withEdgeInsets: .all(Constants.containerSpacing))

        scrollView.contentView.addSubview(crossButton) {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
    }

    private func handlePasswordTextField() {
        if isPasswordVisible {
            let eyeImage = UIImage(systemName: "eye")
            passwordTextField.isSecureTextEntry = false
            passwordRightImage.setImage(eyeImage, for: .normal)
        } else {
            let eyeSlashImage = UIImage(systemName: "eye.slash")
            passwordTextField.isSecureTextEntry = true
            passwordRightImage.setImage(eyeSlashImage, for: .normal)
        }
    }

    private func handleConfirmPasswordTextField() {
        if isConfirmPasswordVisible {
            let eyeImage = UIImage(systemName: "eye")
            confirmPasswordTextField.isSecureTextEntry = false
            confirmPasswordRightImage.setImage(eyeImage, for: .normal)
        } else {
            let eyeSlashImage = UIImage(systemName: "eye.slash")
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordRightImage.setImage(eyeSlashImage, for: .normal)
        }
    }
}

// MARK: - Internal extension
extension SignUpView {
    func showNameErrorMessage(message: String) {
        DispatchQueue.main.async {
            self.nameErrorMessageLabel.text = message
        }
    }

    func showEmailErrorMessage(message: String) {
        DispatchQueue.main.async {
            self.emailErrorMessageLabel.text = message
        }
    }

    func showPasswordErrorMessage(message: String) {
        DispatchQueue.main.async {
            self.passwordErrorMessageLabel.text = message
        }
    }
}

// MARK: - View constants
private enum Constants {
    static let textFieldHeight: CGFloat = 50
    static let doneButtonHeight: CGFloat = 50
    static let textFieldSpacing: CGFloat = 6
    static let containerSpacing: CGFloat = 16
}

#if DEBUG
    import SwiftUI
    struct SignUpPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(SignUpView())
        }
    }
#endif