//
//  SelectedHouseViewController.swift
//  REI
//
//  Created by User on 31.05.2023.
//

import AVFoundation
import AVKit
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            viewModel.popScreen()
        }
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
                    self.sendEmail()
                case .onBlueprintTap:
                    viewModel.moveToBlueprint()
                case .onAllaroundTap:
                    viewModel.moveToAllaround()
                case .onVideoTap:
                    self.playVideo()
                case .call:
                    self.call()
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

    private func call() {
        guard let url = URL(string: "tel://+318902345678"),
              UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        UIApplication.shared.open(url)
    }

    private func sendEmail() {
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

    private func playVideo() {
        guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
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
