//
//  AdPhotosViewModel.swift
//  RomaMVVM
//
//  Created by User on 25.05.2023.
//

import Combine
import Foundation

final class AdPhotosViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdPhotosTransition, Never>()

    private lazy var imagesSubject = CurrentValueSubject<[Data], Never>([])
    
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private lazy var sectionsSubject = CurrentValueSubject<[PhotoCollection], Never>([])
    
    private let model: AdCreatingModel
    
     init(model: AdCreatingModel) {
        self.model = model
        super.init()
    }
    
    override func onViewDidLoad() {
        setupBinding()
    }
    func setupBinding() {
        imagesSubject
            .sinkWeakly(self, receiveValue: { (self, images) in
                self.createDataSource()
                self.model.addImages(images)
            })
            .store(in: &cancellables)
    }
    
    func popScreen() {
        transitionSubject.send(.pop)
    }
    
    func addImages(_ images: [Data]) {
        var newImages = images
        newImages.forEach { image in
            if !imagesSubject.value.contains(image) {
                imagesSubject.value.append(image)
            }
        }
    }
    
    func deletePhoto(_ photo: HousePhotoItem) {
        switch photo {
        case .photo(let photo):
            guard let index = imagesSubject.value.firstIndex(of: photo) else {
                return
            }
            imagesSubject.value.remove(at: index)
        }
    }
    
    func createAd() {
        model.createAd()
    }
    
    func createDataSource() {
        let items = imagesSubject.value
            .map {HousePhotoItem.photo($0)}
        let section = PhotoCollection(section: .photo, items: items)
        sectionsSubject.value = [section]
    }
}
