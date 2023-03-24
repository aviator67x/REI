//
//  EditProfileView.swift
//  RomaMVVM
//
//  Created by User on 22.03.2023.
//

import Combine
import UIKit

struct EditUserViewModel {
    let firstName: String
    let lastName: String
    let nickName: String
}

enum EditProfileViewAction {
    case firstNameDidChange(String)
    case lastNameDidChange(String)
    case nickNameDidChange(String)
    
}

final class EditProfileView: BaseView {
    var configuration: Configuration = .name

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

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<EditProfileViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout(configuration)
        setupUI()
        bindActions()
    }

    private func bindActions() {
        firstNameTextField.textPublisher
            .sinkWeakly(self, receiveValue: {(self, text) in
                self.actionSubject.send(.firstNameDidChange(text ?? ""))
            })
            .store(in: &cancellables)
        
        lastNameTextField.textPublisher
            .sinkWeakly(self, receiveValue: {(self, text) in
                self.actionSubject.send(.lastNameDidChange(text ?? ""))
            })
            .store(in: &cancellables)
        
        nickNameTextField.textPublisher
            .sinkWeakly(self, receiveValue: {(self, text) in
                self.actionSubject.send(.nickNameDidChange(text ?? ""))
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8
        firstNameLabel.text = "First"
        firstNameTextField.text = "firstNameTextField"
        lastNameLabel.text = "Last"
        lastNameTextField.text = "lastNameTextField"
        nickNameLable.text = "Nickname"
        nickNameTextField.text = "nickNameTextField"
    }

    private func setupLayout(_ configuration: Configuration) {
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

    private func setupNameConfiguration() {
        let firstNameStack = UIStackView()
        let lastNameStack = UIStackView()
        let nickNameStack = UIStackView()
        [firstNameStack, lastNameStack, nickNameStack].forEach { stack in
            stack.setup(
                axis: .horizontal,
                alignment: .center,
                distribution: .fill,
                spacing: Constants.stackSpacing
            )
        }
        firstNameStack.addSpacer(10)
        firstNameStack.addArranged(firstNameLabel, size: 80)
        firstNameStack.addArranged(firstNameTextField)
        lastNameStack.addSpacer(10)
        lastNameStack.addArranged(lastNameLabel, size: 80)
        lastNameStack.addArranged(lastNameTextField)
        nickNameStack.addSpacer(10)
        nickNameStack.addArranged(nickNameLable, size: 80)
        nickNameStack.addArranged(nickNameTextField)

        stackView.addArrangedSubviews([firstNameStack, lastNameStack, nickNameStack])
    }
    
    func setupEmailConfifguration() {
        
    }
}

// MARK: - View constants
private enum Constants {
    static let stackSpacing: CGFloat = 16
}

// MARK: - extension
extension EditProfileView {
    func updateUI(_ userViewModel: EditUserViewModel) {
        firstNameTextField.text = userViewModel.firstName
        lastNameTextField.text = userViewModel.lastName
        nickNameTextField.text = userViewModel.nickName
    }
}

#if DEBUG
    import SwiftUI
    struct EditProfilePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(EditProfileView())
        }
    }
#endif
