//
//  FindViewModel.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine
import Foundation

final class FindViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FindTransition, Never>()
    
    @Published var sections: [FindCollection] = []
    
   override init() {

        super.init()
    }
    
    override func onViewDidLoad() {
        updateDataSource()
    }
    
    func updateDataSource() {
        guard let imageURL = URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0407-min.jpg") else {
            return
        }
        let model = PhotoCellModel(image: imageURL, street: "Dorpstraat, 41", ort: "1721 BB Broek-op-Langedejk", livingArea: 65, square: 120, numberOfRooms: "5", price: 318000)
        let section: FindCollection = {
            FindCollection(section: .photlo, items: [.photo(model)])
        }()
        
        sections.append(section)
    }
    
}
