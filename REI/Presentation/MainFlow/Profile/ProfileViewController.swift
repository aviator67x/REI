//
//  ProfileViewController.swift
//  REI
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
        title = Localization.profile
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
                        case .name:
                            viewModel.showEditPrifile(configuration: .name)
                        case .email:
                            viewModel.showEditPrifile(configuration: .email)
                        case .dateOfBirth:
                            viewModel.showEditPrifile(configuration: .dateOfBirth)
                        case .password:
                            viewModel.showPassword()
                        }
                    case .userData:
                        showPopup()
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.openGalleryPublisher
            .sink { [unowned self] value in
                if value {
                    imageFromGallery()
                }
            }
            .store(in: &cancellables)

        viewModel.$sections
            .sink { [unowned self] sections in
                self.contentView.setupSnapShot(sections: sections)
            }
            .store(in: &cancellables)
    }

    private func imageFromGallery() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true

            present(imagePicker, animated: true, completion: nil)
        }
    }

    private func imageFromCamera() {
        let cameraVC = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraVC.delegate = self
            cameraVC.sourceType = .camera
            cameraVC.allowsEditing = true

            present(cameraVC, animated: true, completion: nil)
        }
    }

    private func showPopup() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.imageFromCamera()
        }))

        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.viewModel.openGallery()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("User click Dismiss button")
        }))

        present(alert, animated: true)
    }
}

// MARK: - extension UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        var image = UIImage()
        if let possibleImage = info[.editedImage] as? UIImage {
            image = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            image = possibleImage
        } else { return }
        let resizedImage = image.scalePreservingAspectRatio(targetSize: CGSize(width: 120, height: 120))
        guard let imageData = resizedImage.pngData() else { return }
        viewModel.saveAvatar(avatar: imageData)
        dismiss(animated: true)
    }
}
