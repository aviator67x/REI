//
//  ProfileViewController.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit

final class ProfileViewController: BaseViewController<ProfileViewModel> {
    // MARK: - Views
    private let contentView = ProfileView()

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.profile.uppercased()
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case let .selectedItem(item):
                    switch item {
                    case .button:
                        viewModel.logout()
                    case let .plain(title):
                        switch title {
                        case "Name":
                            viewModel.showName()
                        case "Email":
                            viewModel.showEmail()
                        case "Date of birth":
                            viewModel.showBirth()
                        case "Password":
                            viewModel.showPassword()
                        default:
                            break
                        }
                    case .userData:
                    print("Open UIImage picker view")
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.$sections
            .sink { [unowned self] sectins in
                contentView.updateProfileCollection(sectins)
            }
            .store(in: &cancellables)
    }
}
