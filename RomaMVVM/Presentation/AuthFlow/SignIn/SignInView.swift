//
//  SignInView.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 12.12.2021.
//

import Combine
import UIKit

enum SignInViewAction {
    case signInDidTap
    case emailDidChange(String)
    case passwordDidChange(String)
    case phoneOrEmailTextFieldDidReturn
    case forgotPasswordButtonDidTap
    case createAccontDidTap
}

final class SignInView: BaseView {
    // MARK: - Subviews
    private let scrollView = AxisScrollView()
    private let logoView = UIImageView()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailErrorMessageLabel = UILabel()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordErrorMessageLabel = UILabel()
    private let forgotPasswordButton = UIButton()
    private let createAccounButton = UIButton()
    private let signInButton = UIButton()
    private let passwordRightImage = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SignInViewAction, Never>()

    private var isPasswordVisible = false

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

    private func bindActions() {
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

        signInButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.signInDidTap) }
            .store(in: &cancellables)

        createAccounButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.createAccontDidTap)
            }
            .store(in: &cancellables)

        forgotPasswordButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.forgotPasswordButtonDidTap)
            }
            .store(in: &cancellables)

        passwordRightImage.tapPublisher
            .sink { [unowned self] in
                self.isPasswordVisible.toggle()
                handleTap()
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .lightGray
        logoView.image = UIImage(named: "newLogo")
        logoView.tintColor = .orange

        [emailLabel, passwordLabel].forEach { label in
            label.font = UIFont(name: "SFProText-Regular", size: 14)
            label.textColor = .white
        }
        emailLabel.text = "Email"
        passwordLabel.text = "Password"

        [emailErrorMessageLabel, passwordErrorMessageLabel].forEach { label in
            label.text = ""
            label.font = UIFont(name: "SFProText-Regular", size: 14)
            label.textColor = UIColor(named: "error")
            label.numberOfLines = 0
        }

        emailTextField.placeholder = Localization.email
        passwordTextField.placeholder = Localization.password

        let eyeSlashImage = UIImage(systemName: "eye.slash")
        passwordRightImage.setImage(eyeSlashImage, for: .normal)
        passwordRightImage.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordRightImage.frame = CGRect(
            x: CGFloat(passwordTextField.frame.size.width - 25),
            y: CGFloat(5),
            width: CGFloat(25),
            height: CGFloat(25)
        )

        passwordRightImage.tintColor = .lightGray
        passwordTextField.rightView = passwordRightImage
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true

        [emailTextField, passwordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.layer.cornerRadius = 3
        }

        forgotPasswordButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .right

        signInButton.setTitle(Localization.signIn, for: .normal)
        signInButton.backgroundColor = .orange
        signInButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 21)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.rounded(3)

        let firstAttributes: [NSAttributedString.Key: Any] =
            [.foregroundColor: UIColor(named: "textFieldsBackground")]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        let firstString = NSMutableAttributedString(string: "Not a member? ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Create an account", attributes: secondAttributes)
        firstString.append(secondString)
        createAccounButton.setAttributedTitle(firstString, for: .normal)
        createAccounButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        createAccounButton.contentHorizontalAlignment = .center
    }

    private func handleTap() {
        if isPasswordVisible {
            let eyeImage = UIImage(systemName: "eye")
            passwordTextField.isSecureTextEntry = false
            passwordRightImage.setImage(eyeImage, for: .normal)
        } else {
            let eyeSlashImage = UIImage(systemName: "eye.slash")
            passwordTextField.isSecureTextEntry = false
            passwordRightImage.setImage(eyeSlashImage, for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }

    private func setupLayout() {
        scrollView.addSubview(logoView) {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(150)
        }
        
        let stack = UIStackView()
        stack.setup(axis: .vertical, alignment: .fill, distribution: .fill, spacing: Constants.textFieldSpacing)
        stack.addSpacer(200)
        stack.addArranged(emailLabel)
        stack.addArranged(emailTextField, size: Constants.textFieldHeight)
        stack.addArranged(emailErrorMessageLabel)
        stack.addArranged(passwordLabel)
        stack.addArranged(passwordTextField, size: Constants.textFieldHeight)
        stack.addArranged(passwordErrorMessageLabel)
        stack.addArranged(forgotPasswordButton)
        stack.addSpacer(190)
        stack.addArranged(signInButton, size: Constants.signInButtonHeight)
        stack.addArranged(createAccounButton)

        addSubview(scrollView, withEdgeInsets: .zero, safeArea: true, bottomToKeyboard: false)
        scrollView.contentView.addSubview(stack, withEdgeInsets: .all(Constants.containerSpacing))
    }
}

// MARK: - Internal extension
extension SignInView {
    func setSignInButton(enabled: Bool) {
        signInButton.isEnabled = enabled
        signInButton.alpha = enabled ? 1 : 0.5
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
    static let signInButtonHeight: CGFloat = 50
    static let textFieldSpacing: CGFloat = 6
    static let containerSpacing: CGFloat = 16
}

#if DEBUG
    import SwiftUI
    struct SignInPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(SignInView())
        }
    }
#endif
