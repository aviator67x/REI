//
//  HomeViewController.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 20.11.2021.
//

import UIKit

final class HomeViewController: BaseViewController<HomeViewModel> {
    // MARK: - Views
    private let contentView = HomeView()

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        title = Localization.home.uppercased()
        pickerSetup()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .avatarButtonDidTap:
                    viewModel.saveAvatar()
                }
            }
            .store(in: &cancellables)

        viewModel.userPublisher
            .sink { [unowned self] user in
                guard let user = user else { return }
                contentView.updateUser(user)
            }
            .store(in: &cancellables)
    }

    private func pickerSetup() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true

            present(imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - extension UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
        contentView.updateGalleryImage(image: image)
        guard let imageData = image.pngData() else { return }
        viewModel.updateImageSubject(with: imageData)
        dismiss(animated: true)
    }
}
