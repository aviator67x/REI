//
//  AdPhotosViewController.swift
//  RomaMVVM
//
//  Created by User on 25.05.2023.
//

import PhotosUI
import UIKit

final class AdPhotosViewController: BaseViewController<AdPhotosViewModel> {
    // MARK: - Views
    private let contentView = AdPhotosView()
    private var phPickerViewControlller: PHPickerViewController!

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
        phPickerViewControlller = phPicker()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func phPicker() -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 10
        config.filter = PHPickerFilter.images

        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        return pickerViewController
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .crossDidTap:
                    viewModel.moveToMyHouse()
                case .backDidTap:
                    viewModel.popScreen()
                case .addPhotoDidTap:
                    self.present(phPickerViewControlller, animated: true, completion: nil)
                case .createAdDidTap:
                    viewModel.createAd()
                case .deletePhoto(let photo):
                    viewModel.deletePhoto(photo)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapshot(sections: sections)
            })
            .store(in: &cancellables)
    }
}

// MARK: - extension
extension AdPhotosViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let dispatchGroup = DispatchGroup()
        var images = [Data]()
        picker.dismiss(animated: true, completion: nil)
        for result in results {
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { object, _ in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        debugPrint(image)
                        guard let imageData = image.pngData() else {
                            return
                        }
                        debugPrint(imageData)
                        images.append(imageData)
                    }
                }
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.viewModel.addImages(images)
        }
    }
}
