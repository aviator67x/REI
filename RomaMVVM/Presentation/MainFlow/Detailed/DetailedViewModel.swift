//
//  ConstructionYearViewModel.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import Combine

final class DetailedViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<DetailedTransition, Never>()
    
    private(set) lazy var popDetailedPublisher = popDetailedSubject.eraseToAnyPublisher()
    private let popDetailedSubject = PassthroughSubject<Bool, Never>()

    @Published private(set) var sections: [DetailedCollection] = []
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
        switch text {
        case "since 1850", "since 1900", "since 1950", "since 2000", "since 2010", "since 2020":
            requestModel.constructionYear = text
        default:
            requestModel.garage = text
        }
        popDetailedSubject.send(true)
    }

    private func createDataSource() {
        switch screenState {
        case .year:
            let section: DetailedCollection = {
               DetailedCollection(
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
            let section: DetailedCollection = {
               DetailedCollection(
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
