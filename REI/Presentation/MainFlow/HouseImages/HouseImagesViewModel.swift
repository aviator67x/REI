//
//  HouseImagesViewModel.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import Combine
import Foundation

final class HouseImagesViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<HouseImagesTransition, Never>()
    
    private lazy var imagesSubject = CurrentValueSubject<[URL], Never>([])
    
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private lazy var sectionsSubject = CurrentValueSubject<[HouseImagesCollection], Never>([])
    
    private var images: [URL] = []
    
    init(images: [URL]) {
        self.images = images
        super.init()
    }
    
    override func onViewDidLoad() {
        imagesSubject.value = images
        setupBinding()
    }
    
    func popScreen() {
        self.transitionSubject.send(.popScreen)
    }
}
    
    // MARK: - private extension
    private extension HouseImagesViewModel {
        private func setupBinding() {
            imagesSubject
                .sinkWeakly(self, receiveValue: { (self, images) in
                    self.createDataSource()
                })
                .store(in: &cancellables)
        }
        
        func createDataSource() {
            let items = imagesSubject.value
                .map {HouseImagesItem.photo($0)}
            let section = HouseImagesCollection(section: .photo, items: items)
            sectionsSubject.value = [section]
        }
    }

    

