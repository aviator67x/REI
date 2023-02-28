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
    private let backgroundView = UIImageView()
    private let logoView = UIImageView()
    private let scrollView = AxisScrollView()
    private let emailTextField = UITextField()
    private let emailErrorMessageLabel = UILabel()

    private let passwordTextField = UITextField()
    private let passwordErrorMessageLabel = UILabel()
    private let forgotPasswordButton = UIButton()
    private let createAccounButton = UIButton()
    private let signInButton = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SignInViewAction, Never>()

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
        animation()
    }

    private func animation() {
        let originalTransform = logoView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.5, y: 0.5)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(
            x: -UIScreen.main.bounds.width / 1.6,
            y: -UIScreen.main.bounds.height / 1.4
        )
        UIView.animate(withDuration: 1, delay: 1, animations: {
            self.logoView.transform = scaledAndTranslatedTransform
        }) {
            _ in
            let originalTransform = self.scrollView.transform
            UIView.animate(withDuration: 1, animations: {
                self.scrollView.alpha = 1
            })
        }
    }

    func setSignInButton(enabled: Bool) {
        signInButton.isEnabled = enabled
        signInButton.alpha = enabled ? 1 : 0.5
    }

    private func bindActions() {
        emailTextField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] in actionSubject.send(.emailDidChange($0)) }
            .store(in: &cancellables)

        passwordTextField.textPublisher
            .replaceNil(with: "")
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
            .sink{ [unowned self] in
                actionSubject.send(.forgotPasswordButtonDidTap)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .yellow
        backgroundView.image = UIImage(named: "launchBackground")
        scrollView.alpha = 0
        logoView.image = UIImage(named: "logo")

        emailTextField.placeholder = Localization.email
        emailTextField.text = "superMegaJamesBond@mi6.co.u"

        emailErrorMessageLabel.text = ""
        emailErrorMessageLabel.font = UIFont.systemFont(ofSize: 12)
        emailErrorMessageLabel.textColor = UIColor(named: "error")
        emailErrorMessageLabel.numberOfLines = 0

        passwordTextField.placeholder = Localization.password
        passwordTextField.text = "supe3rs3cre3"

        passwordErrorMessageLabel.text = ""
        passwordErrorMessageLabel.font = UIFont.systemFont(ofSize: 12)
        passwordErrorMessageLabel.textColor = UIColor(named: "error")
        passwordErrorMessageLabel.numberOfLines = 0

        [emailTextField, passwordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.layer.cornerRadius = 6
        }

        forgotPasswordButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 23)
        forgotPasswordButton.setTitleColor(UIColor(named: "linkButtonColor"), for: .normal)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .right

        signInButton.setTitle(Localization.signIn, for: .normal)
        signInButton.backgroundColor = UIColor(named: "fillButtonBackground")
        signInButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 26)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.rounded(6)

        let firstAttributes: [NSAttributedString.Key: Any] =
            [.foregroundColor: UIColor(named: "secondaryTextColor")]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "linkButtonColor")]
        let firstString = NSMutableAttributedString(string: "Not a member? ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Create an account", attributes: secondAttributes)
        firstString.append(secondString)
        createAccounButton.setAttributedTitle(firstString, for: .normal)
        createAccounButton.titleLabel?.font = UIFont(name: "SFProTextRegular", size: 13)
        createAccounButton.contentHorizontalAlignment = .center
    }

    private func setupLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        logoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoView)
        logoView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        logoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let stack = UIStackView()
        stack.setup(axis: .vertical, alignment: .fill, distribution: .fill)
        stack.addSpacer(250)
        stack.addArranged(emailTextField, size: Constants.textFieldHeight)
        stack.addSpacer(6)
        stack.addArranged(emailErrorMessageLabel)
        stack.addSpacer(16)
        stack.addArranged(passwordTextField, size: Constants.textFieldHeight)
        stack.addSpacer(6)
        stack.addArranged(passwordErrorMessageLabel)
        stack.addSpacer(6)
        stack.addArranged(forgotPasswordButton)
        stack.addSpacer(32)
        stack.addArranged(signInButton, size: Constants.signInButtonHeight)
        stack.addSpacer(16)
        stack.addArranged(createAccounButton)

        addSubview(scrollView, withEdgeInsets: .zero, safeArea: true, bottomToKeyboard: false)
        scrollView.contentView.addSubview(stack, withEdgeInsets: .all(Constants.containerSpacing))
    }
}

// MARK: - Internal extension
extension SignInView {
    func setsignInButton(enabled: Bool) {
        signInButton.isEnabled = enabled
    }

//    func setScrollViewOffSet(offSet: CGFloat) {
//        scrollView.contentInset.bottom = offSet - safeAreaInsets.bottom
//    }

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
    static let textFieldSpacing: CGFloat = 16
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
