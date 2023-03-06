//
//  SignUpView.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 12.12.2021.
//

import UIKit
import Combine

enum SignUpViewAction {
    case nameDidChange(String)
    case emailDidChange(String)
    case passwordDidChange(String)
    case confirmPasswordDidChange(String)
    case signUpDidTap
}

final class SignUpView: BaseView {
    // MARK: - Subviews
    private let backgroundView = UIImageView()
    private let logoView = UIImageView()
    private let scrollView = AxisScrollView()
    private let nameTextField = UITextField()
    private let nameErrorMessageLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailErrorMessageLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordErrorMessageLabel = UILabel()
    private let confirmPasswordTextField = UITextField()
    private let confirmPasswordErrorMessageLabel = UILabel()
    private let signUpButton = BaseButton(buttonState: .signUp)

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SignUpViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    func setDoneButton(enabled: Bool) {
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
            .sink { [unowned self] in actionSubject.send(.emailDidChange($0)) }
            .store(in: &cancellables)

        passwordTextField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] in actionSubject.send(.passwordDidChange($0)) }
            .store(in: &cancellables)

        confirmPasswordTextField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] in actionSubject.send(.confirmPasswordDidChange($0)) }
            .store(in: &cancellables)

        signUpButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.signUpDidTap) }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        backgroundView.image = UIImage(named: "launchBackground")
        logoView.image = UIImage(named: "loggogo")
        nameTextField.placeholder = Localization.name
        nameTextField.text = "Bluberry"
        emailTextField.placeholder = Localization.email
        emailTextField.text = "bluberry@mail.co"
        passwordTextField.placeholder = Localization.password
        passwordTextField.text = "Tasty@123"
        confirmPasswordTextField.placeholder = Localization.confirmPassword
        confirmPasswordTextField.text = "Tasty@123"

        [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.layer.cornerRadius = 6
        }
        
        [nameErrorMessageLabel, emailErrorMessageLabel, passwordErrorMessageLabel].forEach { item in
            item.font = UIFont(name: "SFProText-Regular", size: 13)
            item.textColor = UIColor(named: "error")
            item.numberOfLines = 0
        }
    }

    private func setupLayout() {
        addSubview(backgroundView) { _ in
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        addSubview(logoView) { _ in
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerSpacing).isActive = true
            logoView.topAnchor.constraint(equalTo: topAnchor, constant: 80).isActive = true
            logoView.widthAnchor.constraint(equalToConstant: 120).isActive = true
            logoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
        let stack = UIStackView()
        stack.setup(axis: .vertical, alignment: .fill, distribution: .fill, spacing: Constants.textFieldSpacing)
        stack.addSpacer(200)
        stack.addArranged(nameTextField, size: Constants.textFieldHeight)
        stack.addArranged(nameErrorMessageLabel)
        stack.addArranged(emailTextField, size: Constants.textFieldHeight)
        stack.addArranged(emailErrorMessageLabel)
//        stack.addSpacer(50)
        stack.addArranged(passwordTextField, size: Constants.textFieldHeight)
        stack.addArranged(passwordErrorMessageLabel)
        stack.addArranged(confirmPasswordTextField, size: Constants.textFieldHeight)
        stack.addSpacer(100)
        stack.addArranged(signUpButton, size: Constants.doneButtonHeight)

        addSubview(scrollView, withEdgeInsets: .zero, safeArea: true, bottomToKeyboard: true)
        scrollView.contentView.addSubview(stack, withEdgeInsets: .all(Constants.containerSpacing))
    }
    
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
