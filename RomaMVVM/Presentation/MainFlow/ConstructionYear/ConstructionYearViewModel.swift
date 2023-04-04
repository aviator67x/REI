//
//  ConstructionYearViewModel.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import Combine

enum ScreenState {
    case year
    case garage
}

final class ConstructionYearViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<ConstructionYearTransition, Never>()

    @Published private(set) var sections: [ConstructionYearCollection] = []
    @Published var requestModel: SearchRequestModel
    var screenState: ScreenState

   init(requestModel: SearchRequestModel, screenState: ScreenState) {
        self.requestModel = requestModel
       self.screenState = screenState
        super.init()
    }

    override func onViewDidLoad() {
        createDataSource()
    }
    
    func updateRequestModel(_ text: String) {
        requestModel.constructionYear = text
    }

    private func createDataSource() {
        switch screenState {
        case .year:
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
        case .garage:
            let section: ConstructionYearCollection = {
               ConstructionYearCollection(
                    section: .plain,
                    items: [
                        .plain("garage"),
                        .plain("free parking"),
                        .plain("municipal parking"),
                        .plain("hourly payable parking"),
                        .plain("no paarking"),
                    ]
                )
            }()
            sections = [section]
        }
    }
}
