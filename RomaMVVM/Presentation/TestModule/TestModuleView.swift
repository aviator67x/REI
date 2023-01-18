//
//  TestModuleView.swift
//  RomaMVVM
//
//  Created by User on 16.01.2023.
//

import SnapKit
import Combine

protocol TestModuleViewProtocol: AnyObject {
    func createAccountView()
    func loginButtonTapped(login: String?, password: String?)
    func forgotPasswordButtonTapped()
}

enum TestModuleViewAction {

}

final class TestModuleView: BaseView {
       
        weak var delegate: TestModuleViewProtocol?
        
        // MARK: - Private
        
//        private var forgotButtonTopConstraint: ConstraintMakerEditable?
        
        // MARK: - Subviews
        
        private lazy var scrollView: UIScrollView = {
            let view = UIScrollView()
            view.backgroundColor = .clear
            view.showsVerticalScrollIndicator = false
            return view
        }()
        
        private lazy var containerStackView: UIStackView = {
            let view = UIStackView()
            view.spacing = 32
            view.axis = .vertical
            view.backgroundColor = .clear
            view.isLayoutMarginsRelativeArrangement = true
            view.layoutMargins = .init(
                top: Constants.leftAndRightPadding,
                left: Constants.leftAndRightPadding,
                bottom: Constants.leftAndRightPadding,
                right: Constants.leftAndRightPadding
            )
            return view
        }()
        
        private lazy var bottomSpacerView: UIView = {
            let view = UIView()
            return view
        }()
        
        private lazy var loginStackView: UIStackView = {
            let view = UIStackView()
            view.spacing = Constants.leftAndRightPadding
            view.axis = .vertical
            view.backgroundColor = .white
            return view
        }()
    
    lazy var loginButton = UIButton {
        $0.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

        private lazy var loginImage: UIImageView = {
            let image = UIImageView()
            image.image = Asset.Images.internGramLogo.image
            image.contentMode = .scaleAspectFit
            return image
        }()
        
        private lazy var phoneOrEmailTextField: TextFieldView = {
            let textfield = TextFieldView(type: .phoneOrEmail)
            textfield.textField.didChangeSelection = { _ in
                self.textFieldDidChange()
            }
            return textfield
        }()
        
        private lazy var passwordTextField: TextFieldView = {
            let textfield = TextFieldView(type: .passwordWithoutVerification)
            textfield.textField.didChangeSelection = { _ in
                self.textFieldDidChange()
            }
            return textfield
        }()
        
        private lazy var forgotPasswordButton: UIButton = {
            let button = UIButton()
            button.setTitle(L10n.LoginViewController.ForgotPasswordButton.title, for: .normal)
            button.setTitleColor(Asset.Colors.linkButtonColor.color, for: .normal)
            button.titleLabel?.font = UIFont.sfProTextBold(size: 13)
            button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
            button.contentHorizontalAlignment = .right
            return button
        }()
        
        private lazy var orLabel: UILabel = {
            let label = UILabel()
            label.text = L10n.LoginViewController.OrLabel.title
            label.font = UIFont.sfProTextBold(size: 13)
            label.textColor = Asset.Colors.secondaryTextColor.color
            label.textAlignment = .center
            return label
        }()
        
        private lazy var facebookButton: UIButton = {
            let button = UIButton()
            button.setImage(Asset.Images.facebookLogo.image, for: .normal)
            button.setTitle(L10n.LoginViewController.LoginWithFBButton.title, for: .normal)
            button.titleLabel?.font = UIFont.sfProTextBold(size: 13)
            button.setTitleColor(Asset.Colors.fillButtonBackground.color, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            return button
        }()
        
        private lazy var googleButton: UIButton = {
            let button = UIButton()
            button.setImage(Asset.Images.googleLogo.image, for: .normal)
            button.setTitle(L10n.LoginViewController.LoginWithGoogleButton.title, for: .normal)
            button.setTitleColor(Asset.Colors.fillButtonBackground.color, for: .normal)
            button.titleLabel?.font = UIFont.sfProTextBold(size: 13)
            button.imageView?.contentMode = .scaleAspectFill
            return button
        }()
        
        private lazy var stackOfButtons: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 22
            stack.distribution = .fill
            stack.addArrangedSubview(facebookButton)
            stack.addArrangedSubview(googleButton)
            return stack
        }()
        
        private lazy var createAccountTextView: UITextView = {
            let textView = UITextView()
            textView.backgroundColor = .none
            textView.isEditable = false
            textView.isScrollEnabled = false
            textView.delegate = self
            textView.text = Constants.createAnAccountFullLine
            textView.attributedText = NSAttributedString.makeHyperlink(
                for: Constants.createAnAccountURL,
                in: textView.text,
                as: Constants.createAnAccountLink
            )
            textView.font = UIFont.sfProTextRegular(size: 13)
            textView.textColor = Asset.Colors.secondaryTextColor.color
            textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: Asset.Colors.linkButtonColor.color]
            textView.textAlignment = .center
            return textView
        }()
        
        // MARK: - Lifecycle
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = Asset.Colors.backgroundColor.color
            addSubviews()
            addConstraints()
            phoneOrEmailTextField.buttonDelegate = self
            passwordTextField.buttonDelegate = self
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - TextFieldDidChange
        private func textFieldDidChange() {
            passwordTextField.changeTextFieldState(state: .valid)
            phoneOrEmailTextField.changeTextFieldState(state: .valid)
        }
    }

    // MARK: - Internal extension
    extension TestModuleView {
        func setScrollViewOffSet(offSet: CGFloat) {
            scrollView.contentInset.bottom = offSet - safeAreaInsets.bottom
        }
        
        func showErrorMessage() {
            DispatchQueue.main.async {
                self.passwordTextField.showErrorMessageForPassword()
                self.phoneOrEmailTextField.textField.fieldState = .invalid(errorMessage: "")
            }
        }
        
        func showEmptyErrorMessage() {
            DispatchQueue.main.async {
                self.passwordTextField.showEmptyErrorMessage()
                self.phoneOrEmailTextField.showEmptyErrorMessage()
            }
        }
    }

    // MARK: - Buttons actions
    extension TestModuleView {
        @objc
        private func loginButtonDidTap() {
            delegate?.loginButtonTapped(login: phoneOrEmailTextField.textField.text,
                                        password: passwordTextField.textField.text)
        }
        
        @objc
        private func forgotPasswordButtonTapped() {
            delegate?.forgotPasswordButtonTapped()
        }
    }

    // MARK: - Set Constaints
    private extension TestModuleView {
        func addConstraints() {
            scrollView.snp.makeConstraints {
                $0.top.equalTo(snp.top)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
                $0.left.equalTo(snp.left)
                $0.right.equalTo(snp.right)
                $0.width.equalTo(snp.width)
            }
            
            containerStackView.snp.makeConstraints {
                $0.edges.equalTo(scrollView)
                $0.width.equalTo(scrollView.snp.width)
                $0.height.greaterThanOrEqualTo(safeAreaLayoutGuide)
            }
            
            loginImage.snp.makeConstraints { $0.height.equalTo(48) }
            loginButton.snp.makeConstraints { $0.height.equalTo(44) }
            bottomSpacerView.snp.makeConstraints { $0.height.lessThanOrEqualTo(50) }
        }
        
        func addSubviews() {
            addSubview(scrollView)
            scrollView.addSubview(containerStackView)
            containerStackView.addArrangedSubviews(
                [
                    UIView(),
                    loginImage,
                    loginStackView,
                    loginButton,
                    orLabel,
                    stackOfButtons,
                    bottomSpacerView,
                    createAccountTextView
                ]
            )
            
            loginStackView.addArrangedSubviews(
                [
                    phoneOrEmailTextField,
                    passwordTextField,
                    forgotPasswordButton
                ]
            )
        }
    }

    // MARK: - TextFieldButtonDelegate
    extension LoginView: TextFieldButtonDelegate {
        func returnButtonDidTap() {
            self.endEditing(true)
        }
    }

    // MARK: - UITextViewDelegate
    extension LoginView: UITextViewDelegate {
        func textView(
            _ textView: UITextView,
            shouldInteractWith URL: URL,
            in characterRange: NSRange,
            interaction: UITextItemInteraction
        ) -> Bool {
            delegate?.createAccountView()
            return false
        }
    }

    // MARK: - Constants
    private enum Constants {
        static let createAnAccountFullLine = L10n.LoginViewController.NotAMemberView.title
        static let createAnAccountLink = L10n.LoginViewController.CreateAnAccountLink.title
        static let createAnAccountURL = "createAnAccount"
        static let leftAndRightPadding: CGFloat = 16
    }

    // MARK: - Subviews


    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<TestModuleViewAction, Never>()
    let anotherActionSubject = PassthroughSubject<Bool, Never>()

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

    private func bindActions() {
    }

    private func setupUI() {
        backgroundColor = .white
    }

    private func setupLayout() {
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct TestModulePreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(TestModuleView())
    }
}
#endif
