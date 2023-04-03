//
//  ConstructionYearViewModel.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import Combine

final class ConstructionYearViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<ConstructionYearTransition, Never>()

    @Published private(set) var sections: [ConstructionYearCollection] = []
    @Published var requestModel: SearchRequestModel

   init(requestModel: SearchRequestModel) {
        self.requestModel = requestModel
        super.init()
    }

    override func onViewDidLoad() {
        createDataSource()
    }
    
    func updateRequestModel(_ text: String) {
        requestModel.constructionYear = text
    }

    private func createDataSource() {
        let section: ConstructionYearCollection = {
           ConstructionYearCollection(
                section: .plain,
                items: [
                    .plain("since 1850"),
                    .plain("since 1900"),
                    .plain("since 1950"),
                    .plain("since 2000"),
                    .plain("since 2010"),
                    .plain("since 2020"),
                ]
            )
        }()
        sections = [section]
    }
}
