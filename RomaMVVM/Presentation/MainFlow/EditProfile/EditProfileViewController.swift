//
//  EditProfileViewController.swift
//  RomaMVVM
//
//  Created by User on 22.03.2023.
//

import UIKit

final class EditProfileViewController: BaseViewController<EditProfileViewModel> {
    // MARK: - Views
    private let contentView = EditProfileView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                }
            }
            .store(in: &cancellables)
    }
}
