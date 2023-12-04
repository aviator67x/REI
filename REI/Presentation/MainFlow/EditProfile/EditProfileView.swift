//
//  EditProfileView.swift
//  REI
//
//  Created by User on 22.03.2023.
//

import Combine
import UIKit

enum EditProfileViewAction {
    case firstNameDidChange(String)
    case lastNameDidChange(String)
    case nickNameDidChange(String)
    case emailDidCange(String)
}

final class EditProfileView: BaseView {
    // MARK: - Subviews
    private var scrollView = AxisScrollView()
    private let stackView = UIStackView()
    private let firstNameView = UIView()
    private let firstNameLabel = UILabel()
    private let firstNameTextField = UITextField()
    private let lastNameView = UIView()
    private let lastNameLabel = UILabel()
    private let lastNameTextField = UITextField()
    private let nickNameView = UIView()
    private let nickNameLable = UILabel()
    private let nickNameTextField = UITextField()
    private let emailTextField = UITextField()
    private let emailLabel = UILabel()
 

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<EditProfileViewAction, Never>()

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
    private func initialSetup() {
        setupUI()
        bindActions()
    }

    private func bindActions() {
        firstNameTextField.textPublisher
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.firstNameDidChange(text ?? ""))
            })
            .store(in: &cancellables)

        lastNameTextField.textPublisher
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.lastNameDidChange(text ?? ""))
            })
            .store(in: &cancellables)

        nickNameTextField.textPublisher
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.nickNameDidChange(text ?? ""))
            })
            .store(in: &cancellables)
        
        emailTextField.textPublisher
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.actionSubject.send(.emailDidCange(text ?? ""))
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8
        firstNameLabel.text = " First"
        lastNameLabel.text = " Last"
        nickNameLable.text = " Nickname"
        emailLabel.text = " Waiting for updated email"
        emailTextField.placeholder = "Please enter your new email"
    }

    private func setupNameConfiguration() {
        let firstNameStack = UIStackView()
        let lastNameStack = UIStackView()
        let nickNameStack = UIStackView()
        [firstNameStack, lastNameStack, nickNameStack].forEach { stack in
            stack.setup(
                axis: .horizontal,
                alignment: .center,
                distribution: .fillProportionally,
                spacing: Constants.stackSpacing
            )
        }
        firstNameStack.addSpacer(10)
        firstNameStack.addArranged(firstNameLabel, size: 90)
        firstNameStack.addArranged(firstNameTextField)
        lastNameStack.addSpacer(10)
        lastNameStack.addArranged(lastNameLabel, size: 90)
        lastNameStack.addArranged(lastNameTextField)
        nickNameStack.addSpacer(10)
        nickNameStack.addArranged(nickNameLable, size: 90)
        nickNameStack.addArranged(nickNameTextField)

        stackView.addArrangedSubviews([firstNameStack, lastNameStack, nickNameStack])
    }

    private func setupEmailConfifguration() {
        let emailStackView = UIStackView()

        emailStackView.setup(
            axis: .vertical,
            alignment: .center,
            distribution: .fillProportionally,
            spacing: Constants.stackSpacing
        )

        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        stackView.addArrangedSubview(emailStackView)
    }
}

// MARK: - Internal extension
extension EditProfileView {
    func setupLayout(_ configuration: EditProfileConfiguration) {
        stackView.setup(axis: .vertical, alignment: .fill, distribution: .fill, spacing: Constants.stackSpacing)
        addSubview(scrollView) {
            $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
        scrollView.contentView.addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(
                top: 50,
                left: Constants.stackSpacing,
                bottom: 100,
                right: Constants.stackSpacing
            )
        )

        switch configuration {
        case .name:
            setupNameConfiguration()
        case .email:
            setupEmailConfifguration()
        case .dateOfBirth:
            break
        case .password:
            break
        }
    }

    func updateUI(_ userViewModel: EditUserViewModel) {
        firstNameTextField.text = userViewModel.firstName
        lastNameTextField.text = userViewModel.lastName
        nickNameTextField.text = userViewModel.nickName
        emailTextField.text = userViewModel.email
    }
}

// MARK: - View constants
private enum Constants {
    static let stackSpacing: CGFloat = 16
}

#if DEBUG
    import SwiftUI
    struct EditProfilePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(EditProfileView())
        }
    }
#endif
