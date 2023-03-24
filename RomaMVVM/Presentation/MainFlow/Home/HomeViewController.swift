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
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .avatarButtonDidTap:
                    print("button did tap")
                case .chosePhotoDidTap:
                    viewModel.showGallery()
                case .logoutDidTap:
                    viewModel.logOut()
                }
            }
            .store(in: &cancellables)

        viewModel.userPublisher
            .sink { [unowned self] user in
                guard let user = user else { return }
                contentView.updateUser(user)
            }
            .store(in: &cancellables)
        
        viewModel.universalImagePublisher
            .sinkWeakly(self, receiveValue: { (self, image) in
                guard let image = image else { return }
                self.contentView.setAvatar(imageResource: image)
            })
            .store(in: &cancellables)
        
        viewModel.showPhotoPublisher
            .sink { [unowned self] value in
                if value {
                    imagePickerSetup()
                }
        }
            .store(in: &cancellables)
    }

    private func imagePickerSetup() {
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
        guard let imageData = image.pngData() else { return }
        viewModel.updateUniversalImageSubject(with: .imageData(imageData))
        dismiss(animated: true)
    }
}
