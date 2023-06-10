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
    
    func popScreen() {
        self.transitionSubject.send(.popScreen)
    }
    
    func moveToMyHouse() {
        self.transitionSubject.send(.myHouse)
    }
    
    func addImages(_ images: [Data]) {
        images.forEach { image in
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
}
    // MARK: - private extension
    private extension AdPhotosViewModel {
        private func setupBinding() {
            imagesSubject
                .sinkWeakly(self, receiveValue: { (self, images) in
                    self.createDataSource()
                    self.model.addImages(images)
                })
                .store(in: &cancellables)
            
            model.transitionPublisher
                .sinkWeakly(self, receiveValue: { (self, value) in
                    self.transitionSubject.send(.myHouse)
                })
                    .store(in: &cancellables)
            
            model.isLoadingPublisher
                .sinkWeakly(self, receiveValue: { (self, value) in
                    self.isLoadingSubject.send(value)
                })
                .store(in: &cancellables)
        }
        
        func createDataSource() {
            let items = imagesSubject.value
                .map {HousePhotoItem.photo($0)}
            let section = PhotoCollection(section: .photo, items: items)
            sectionsSubject.value = [section]
        }
    }

