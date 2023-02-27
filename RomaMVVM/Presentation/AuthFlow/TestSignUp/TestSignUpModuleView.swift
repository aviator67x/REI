//
//  TestSignUpModuleView.swift
//  RomaMVVM
//
//  Created by User on 03.02.2023.
//

import SnapKit
import Combine

enum TestSignUpModuleViewAction {
case signUpDidTap
}

final class TestSignUpModuleView: BaseView {
    // MARK: - Subvie
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<TestSignUpModuleViewAction, Never>()
      
    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.titleText
        label.numberOfLines = 2
        label.font = UIFont(name: "SF-Pro-Text-Bold", size: 20)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(named: "backgroundColor")
        return containerView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.removeBorders()
        
        segmentedControl.insertSegment(withTitle: "Phone", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Email", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0

        return segmentedControl
    }()
    
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor.black
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var phoneStack = UIStackView {
        $0.spacing = 5
        $0.axis = .vertical
        $0.backgroundColor = .white
    }
    
    private lazy var phoneTextField: TextField = {
        let textfield = TextField(type: .phone)
        textfield.placeholder = "Phone or Email"
        return textfield
    }()
    
    private lazy var phoneMessageLabel = UILabel {
        $0.text = "phoneLabel"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "error")
        $0.numberOfLines = 0
    }
    
    private lazy var emailStack = UIStackView {
        $0.spacing = 5
        $0.axis = .vertical
        $0.backgroundColor = .white
    }
    
    private lazy var emailTextField: TextField = {
        let textfield = TextField(type: .email)
        textfield.placeholder = "Phone or Email"
        return textfield
    }()
    
    private lazy var emailMessageLabel = UILabel {
        $0.text = "phoneLabel"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "error")
        $0.numberOfLines = 0
    }
  
    
    private lazy var signUpButton: BaseButton = {
        let button = BaseButton(buttonState: .next)
        button.setTitle("Sing Up", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var termsAndConditionsTextView: UIButton = {
        
        let button = UIButton()
        
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "lightSecondaryText")]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "lightSecondaryText"), .underlineStyle: 1]
        let firstString = NSMutableAttributedString(string: Constant.termsAndConditionsFullLine, attributes: firstAttributes)
        let secondString = NSAttributedString(string: Constant.termsAndConditionslinkString, attributes: secondAttributes)
        firstString.append(secondString)
        
        button.setAttributedTitle(firstString, for: .normal)
        button.titleLabel?.font = UIFont(name: "sfProTextRegular", size: 12)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    private lazy var segmentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var loginTextView: UIButton = {

        let button = UIButton()
        
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "secondaryTextColor")]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "linkButtonColor")]
        let firstString = NSMutableAttributedString(string: Constant.haveAnAccountLine, attributes: firstAttributes)
        let secondString = NSAttributedString(string: Constant.loginLinkString, attributes: secondAttributes)
        firstString.append(secondString)
        
        button.setAttributedTitle(firstString, for: .normal)
        button.titleLabel?.font = UIFont(name: "sfProTextRegular", size: 13)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Private Exension
extension TestSignUpModuleView {
    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
        signUpButton.tapPublisher
            .sink { [unowned self] in
                self.actionSubject.send(.signUpDidTap)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
            backgroundColor = UIColor(named: "backgroundColor")
            configureTitleLAbel()
            configureSegmentedContainerView()
            configureSegmentedControl()
            configureBottomUnderline()
            configurePhoneTextField()
            configureNextButton(below: phoneStack)
            configureTermsAndConditionView()
            configureSegmentView()
            configureLoginTextView()
            phoneTextField.becomeFirstResponder()
        }
    
    func setSignUpButton(enabled: Bool) {
        signUpButton.isEnabled = enabled
    }

        func configureTitleLAbel() {
            addSubview(titleLabel) {
                $0.top.equalToSuperview().offset(108)
                $0.width.equalTo(self.snp.width).dividedBy(1.4)
                $0.centerX.equalTo(self.snp.centerX)
                $0.height.equalTo(self.snp.height).dividedBy(14.5)
            }
        }

        func configureSegmentedContainerView() {
            addSubview(segmentedControlContainerView) {
                $0.top.equalTo(titleLabel.snp.bottom).offset(30)
                $0.leading.equalToSuperview().offset(26)
                $0.trailing.equalToSuperview().offset(-26)
                $0.height.equalTo(self.snp.height).dividedBy(27.1)
            }
        }

        private func configureSegmentedControl() {
            segmentedControlContainerView.addSubview(segmentedControl) {
                $0.top.equalTo(segmentedControlContainerView)
                $0.leading.equalTo(segmentedControlContainerView)
                $0.trailing.equalTo(segmentedControlContainerView)
                $0.height.equalTo(segmentedControlContainerView)
            }
        }

        func configureBottomUnderline() {
            segmentedControlContainerView.addSubview(bottomUnderlineView) {
                $0.bottom.equalTo(segmentedControlContainerView.snp.bottom)
                $0.leading.equalTo(segmentedControlContainerView.snp.leading)
                $0.width.equalTo(segmentedControl.snp.width).multipliedBy(1 / CGFloat(segmentedControl.numberOfSegments))
                $0.height.equalTo(1)
            }
        }

        func configurePhoneTextField() {
            phoneStack.addArrangedSubviews([phoneTextField, phoneMessageLabel])
            phoneTextField.becomeFirstResponder()
            addSubview(phoneStack) {
                phoneTextField.snp.makeConstraints {
                    $0.height.equalTo(44)
                }
                $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        }

        func configureEmailTextField() {
            emailStack.addArrangedSubviews([emailTextField, emailMessageLabel])
            emailTextField.becomeFirstResponder()
            addSubview(emailStack) {
                $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
            }
        }

        func configureNextButton(below textField: UIStackView) {
            addSubview(signUpButton) {
                $0.top.equalTo(textField.snp.bottom).offset(16)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.height.equalTo(44)
            }
        }

        func configureTermsAndConditionView() {
            addSubview(termsAndConditionsTextView) {
                $0.top.equalTo(signUpButton.snp.bottom).offset(7)
                $0.leading.leading.equalToSuperview().inset(16)
                $0.height.equalTo(23)
            }
        }

        func configureSegmentView() {
            addSubview(segmentView) {
                $0.bottom.equalTo(self.snp.bottom)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.height.equalTo(self.snp.height).dividedBy(2.8)
            }
        }

        func configureLoginTextView() {
            addSubview(loginTextView) {
                $0.bottom.equalTo(segmentView.snp.top).offset(-10)
                $0.centerX.equalTo(self.snp.centerX)
                $0.height.equalTo(23)
            }
        }

    private func setupLayout() {
    }
}

// MARK: - View constants

private enum Constant {
    static let titleText = "Enter phone number or email address"
    static let termsAndConditionsFullLine = "By signing up you agree with our Terms and Conditions"
    static let termsAndConditionslinkString = "Terms and Conditions"
    static let haveAnAccountLine = "Have an account? "
    static let loginLinkString = "Log in"
    static let alreadyExistEmail = "A user with this email is already registered. Please try entering another email"
    static let alreadyExsistNumber = "A user with this phone number is already registered. Please try entering another phone"
}

#if DEBUG
import SwiftUI
struct TestSignUpModulePreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(TestSignUpModuleView())
    }
}
#endif

