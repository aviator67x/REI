//
//  PasswordRestoreViewController.swift
//  RomaMVVM
//
//  Created by User on 27.02.2023.
//

import UIKit

final class PasswordRestoreViewController: BaseViewController<PasswordRestoreViewModel> {
    // MARK: - Views
    private let contentView = PasswordRestoreView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restore password"
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .restoreDidTap:
                    viewModel.restorePassword()
                case .emailTextFieldDidChange(inputText: let inputText):
                    viewModel.updateEmail(inputText)
                case .crossDidTap:
                    viewModel.popScreen()
                }
            }
            .store(in: &cancellables)
        
        viewModel.isInputValidSubjectPublisher
            .sinkWeakly(self, receiveValue: { (self, value) in
                self.contentView.updateRestoreButton(value)
            })
            .store(in: &cancellables)
        
        viewModel.showAlertPublisher
            .sink { [unowned self] _ in
                let alert = UIAlertController(title: "Incorrect Email", message: "Try another Email address", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
}
