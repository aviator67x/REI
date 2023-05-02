//
//  ConstructionYearViewModel.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import Combine

final class SearchFiltersDetailedViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchFiltersDetailedTransition, Never>()
    
    private(set) lazy var popDetailedPublisher = popDetailedSubject.eraseToAnyPublisher()
    private let popDetailedSubject = PassthroughSubject<Bool, Never>()

    @Published private(set) var sections: [SearchFiltersDetailedCollection] = []
//    @Published var requestModel: SearchRequestModel
    let model: SearchModel
    var screenState: SearchFiltersDetailedScreenState

   init(model: SearchModel, screenState: SearchFiltersDetailedScreenState) {
//        self.requestModel = requestModel
       self.model = model
       self.screenState = screenState
        super.init()
    }

    override func onViewDidLoad() {
        createDataSource()
    }
    
    func updateRequestModel(_ text: String) {
        switch text {
        case "since 1850", "since 1900", "since 1950", "since 2000", "since 2010", "since 2020":
            model.searchRequestModel.constructionYear = text
        default:
            model.searchRequestModel.garage = text
        }
        popDetailedSubject.send(true)
    }

    private func createDataSource() {
        switch screenState {
        case .year:
            let section: SearchFiltersDetailedCollection = {
               SearchFiltersDetailedCollection(
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
            let section: SearchFiltersDetailedCollection = {
               SearchFiltersDetailedCollection(
                    section: .plain,
                    items: [
                        .plain("garage"),
                        .plain("free parking"),
                        .plain("municipal parking"),
                        .plain("hourly payable parking"),
                        .plain("no parking"),
                    ]
                )
            }()
            sections = [section]
        }
    }
}
