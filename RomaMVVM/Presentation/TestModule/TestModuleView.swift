//
//  TestModuleView.swift
//  RomaMVVM
//
//  Created by User on 16.01.2023.
//

import Combine
import SnapKit

enum TestModuleViewAction {
    case loginButtonDidTap
    case phoneOrEmailTextFieldChanged(text: String)
    case phoneOrEmailTextFieldDidReturn
    case passwordTextFieldChanged(String)
    case forgotPasswordButtonDidTap
    case createAccontDidTap
}

final class TestModuleView: BaseView {

    // MARK: - Private
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<TestModuleViewAction, Never>()

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
            top: Constant.leftAndRightPadding,
            left: Constant.leftAndRightPadding,
            bottom: Constant.leftAndRightPadding,
            right: Constant.leftAndRightPadding
        )
        return view
    }()

    private lazy var bottomSpacerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var loginStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constant.leftAndRightPadding
        view.axis = .vertical
        view.backgroundColor = .white
        return view
    }()

    lazy var loginButton: BaseButton = {
        let button = BaseButton(buttonState: .login)
        button.isEnabled = false
        return button
    }()

    private lazy var loginImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "internGramLogo")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var phoneEmailStack = UIStackView {
        $0.spacing = 5
        $0.axis = .vertical
        $0.backgroundColor = .white
    }

    private lazy var phoneOrEmailTextField: TextField = {
        let textfield = TextField(type: .phoneOrEmail)
        textfield.placeholder = "Phone or Email"
        return textfield
    }()
    
    private lazy var phoneEmailErrorMessageLabel = UILabel {
        $0.text = "phoneOrEmailLabel"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "error")
        $0.numberOfLines = 0
    }
    
    private lazy var passwordStack = UIStackView {
        $0.spacing = 5
        $0.axis = .vertical
        $0.backgroundColor = .white
    }

    private lazy var passwordTextField: TextField = {
        let textField = TextField(type: .password)
        textField.placeholder = "Password"
        return textField
    }()
    
    private lazy var passwordErrorMessageLabel = UILabel {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "error")
        $0.numberOfLines = 0
    }

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(UIColor(named: "fillButtonBackground"), for: .normal)
        button.titleLabel?.font = UIFont(name: "SF-Pro-Text-Bold", size: 13)
        button.contentHorizontalAlignment = .right
        return button
    }()

    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = UIFont(name: "SF-Pro-Text-Bold", size: 13)
        label.textColor = UIColor(named: "secondaryTextColor")
        label.textAlignment = .center
        return label
    }()

    private lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "facebookLogo"), for: .normal)
        button.setTitle("Login with Facebook", for: .normal)
        button.titleLabel?.font = UIFont(name: "sfProTextBold", size: 13)
        button.setTitleColor(UIColor(named: "fillButtonBackground"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "googleLogo"), for: .normal)
        button.setTitle("Login with Google", for: .normal)
        button.setTitleColor(UIColor(named: "fillButtonBackground"), for: .normal)
        button.titleLabel?.font = UIFont(name: "sfProTextBold", size: 13)
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

    private lazy var createAccountTextView: UIButton = {
        let button = UIButton()
        
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "secondaryTextColor")]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "linkButtonColor")]
        let firstString = NSMutableAttributedString(string: "Not a member? ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Create an account", attributes: secondAttributes)
        firstString.append(secondString)
        
        button.setAttributedTitle(firstString, for: .normal)
        button.titleLabel?.font = UIFont(name: "sfProTextRegular", size: 13)
        button.contentHorizontalAlignment = .center
        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension
private extension TestModuleView {
    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
        loginButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.loginButtonDidTap)}
            .store(in: &cancellables)
        
        phoneOrEmailTextField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] text in actionSubject.send(.phoneOrEmailTextFieldChanged(text: text)) }
                .store(in: &cancellables)
        
        phoneOrEmailTextField.returnPublisher
            .sink { [unowned self] in actionSubject.send(.phoneOrEmailTextFieldDidReturn)}
            .store(in: &cancellables)
    
        passwordTextField.textPublisher
        .replaceNil(with: "")
        .sink { [unowned self] text in actionSubject.send(.passwordTextFieldChanged(text)) }
            .store(in: &cancellables)
        
        forgotPasswordButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.forgotPasswordButtonDidTap)}
            .store(in: &cancellables)
        
        createAccountTextView.tapPublisher
        
        }

    private func setupUI() {
        backgroundColor = UIColor(named: "backgroundColor")
    }

    private func setupLayout() {
        addSubviews()
        addConstraints()
    }
}

// MARK: - Internal extension
extension TestModuleView {
    func setLoginButton(enabled: Bool) {
        loginButton.isEnabled = enabled
    }
    
    func setScrollViewOffSet(offSet: CGFloat) {
        scrollView.contentInset.bottom = offSet - safeAreaInsets.bottom
    }

    func showPhoneEmailErrorMessage(message: String) {
        DispatchQueue.main.async {
            self.phoneEmailErrorMessageLabel.text = message
        }
    }

    func showPasswordErrorMessage(message: String) {
        DispatchQueue.main.async {
            self.passwordErrorMessageLabel.text = message
        }
    }
}

// MARK: - Set Constraints
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
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        phoneOrEmailTextField.snp.makeConstraints {
            $0.height.equalTo(44)
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
                createAccountTextView,
            ]
        )

        phoneEmailStack.addArrangedSubviews([phoneOrEmailTextField, phoneEmailErrorMessageLabel])
        passwordStack.addArrangedSubviews([passwordTextField, passwordErrorMessageLabel])
        loginStackView.addArrangedSubviews(
            [
                phoneEmailStack,
                passwordStack,
                forgotPasswordButton,
            ]
        )
    }
}

// MARK: - TextFieldButtonDelegate
//    extension TestModuleView: TextFieldButtonDelegate {
//        func returnButtonDidTap() {
//            self.endEditing(true)
//        }
//    }

// MARK: - UITextViewDelegate
extension TestModuleView: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
//        delegate?.createAccountView()
        return false
    }
}

// MARK: - View constants
private enum Constant {
    static let createAnAccountFullLine = "Not a member? Create an account"
    static let createAnAccountLink = "Create an account"
    static let createAnAccountURL = "createAnAccount"
    static let leftAndRightPadding: CGFloat = 16
}

#if DEBUG
    import SwiftUI
    struct TestModulePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(TestModuleView())
        }
    }
#endif
