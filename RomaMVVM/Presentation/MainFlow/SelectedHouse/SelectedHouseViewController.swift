//
//  SelectedHouseViewController.swift
//  RomaMVVM
//
//  Created by User on 31.05.2023.
//

import MessageUI
import UIKit

final class SelectedHouseViewController: BaseViewController<SelectedHouseViewModel> {
    // MARK: - Views
    private let contentView = SelectedHouseView()

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
                case let .navBarAlfaOnScroll(isHidden):
                    self.navigationController?.navigationBar.isHidden = isHidden ? false : false
                case let .onHeartButtonTap(id):
                    viewModel.editFavorites(with: id)
                case .imageDidTap:
                    viewModel.showHouseImages()
                case .sendEmail:
                    sendEmail()
                }
            }
            .store(in: &cancellables)

        viewModel.housePublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, house) in
                self.contentView.setupView(house)
            })
            .store(in: &cancellables)
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            return
        }
    }
}

// MARK: - extension MFMailComposeViewControllerDelegate
extension SelectedHouseViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
