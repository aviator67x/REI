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
    
    func updateRequestModel(year: PeriodOfBuilding) {
            model.updateSearchRequestModel(constructionYear: year)
        popDetailedSubject.send(true)
    }
    
    func updateRequestModel(garage: Garage) {
        model.updateSearchRequestModel(parkingType: garage)
        popDetailedSubject.send(true)
    }

    private func createDataSource() {
        switch screenState {
        case .year:
            let section: SearchFiltersDetailedCollection = {
               SearchFiltersDetailedCollection(
                    section: .plain,
                    items: [
                        .plainYear(.since1850),
                        .plainYear(.since1900),
                        .plainYear(.since1950),
                        .plainYear(.since2000),
                        .plainYear(.since2010),
                        .plainYear(.since2020),
                    ]
                )
            }()
            sections = [section]
        case .garage:
            let section: SearchFiltersDetailedCollection = {
               SearchFiltersDetailedCollection(
                    section: .plain,
                    items: [
                        .plainGarage(Garage.garage),
                        .plainGarage(Garage.freeParking),
                        .plainGarage(Garage.municipalParking),
                        .plainGarage(Garage.hourlyPayableParking),
                        .plainGarage(Garage.noParking),
                    ]
                )
            }()
            sections = [section]
        }
    }
}
