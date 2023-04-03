//
//  EditProfileViewController.swift
//  RomaMVVM
//
//  Created by User on 22.03.2023.
//

import UIKit

enum EditProfileConfiguration {
    case name
    case email
    case dateOfBirth
    case password
}

final class EditProfileViewController: BaseViewController<EditProfileViewModel> {
    // MARK: - Views
    private let contentView = EditProfileView()

    // MARK: - Lifecycle
    init(configuration: EditProfileConfiguration, viewModel: EditProfileViewModel) {
        super.init(viewModel: viewModel)
        contentView.setupLayout(configuration)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        setupNavigationButton()
        setupBindings()
    }

    private func setupNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    @objc
    private func addTapped() {
        viewModel.updateUser()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case let .firstNameDidChange(text):
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    viewModel.update(firstName: text)
                case let .lastNameDidChange(text):
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    viewModel.update(lastName: text)
                case let .nickNameDidChange(text):
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    viewModel.update(nickName: text)
                }
            }
            .store(in: &cancellables)

        viewModel.userPublisher
            .sinkWeakly(self, receiveValue: { (self, user) in
                guard let user = user else { return }
                let userViewModel = EditUserViewModel(
                    firstName: user.firstName,
                    lastName: user.lastName,
                    nickName: user.nickName
                )
                self.contentView.updateUI(userViewModel)
            })
            .store(in: &cancellables)

        viewModel.popEditPublisher
            .sinkWeakly(self, receiveValue: { _, value in
                if value {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .store(in: &cancellables)
    }
}
