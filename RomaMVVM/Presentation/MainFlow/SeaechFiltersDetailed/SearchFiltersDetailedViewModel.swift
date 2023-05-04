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
    
    func updateRequestModel(year: SearchRequestModel.PeriodOfBuilding) {
            model.updateSearchRequestModel(constructionYear: year)
        popDetailedSubject.send(true)
    }
    
    func updateRequestModel(garage: SearchRequestModel.Garage) {
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
                        .plainYear(SearchRequestModel.PeriodOfBuilding.since1850),
                        .plainYear(SearchRequestModel.PeriodOfBuilding.since1900),
                        .plainYear(SearchRequestModel.PeriodOfBuilding.since1950),
                        .plainYear(SearchRequestModel.PeriodOfBuilding.since2000),
                        .plainYear(SearchRequestModel.PeriodOfBuilding.since2010),
                        .plainYear(SearchRequestModel.PeriodOfBuilding.since2020),
                    ]
                )
            }()
            sections = [section]
        case .garage:
            let section: SearchFiltersDetailedCollection = {
               SearchFiltersDetailedCollection(
                    section: .plain,
                    items: [
                        .plainGarage(SearchRequestModel.Garage.garage),
                        .plainGarage(SearchRequestModel.Garage.freeParking),
                        .plainGarage(SearchRequestModel.Garage.municipalParking),
                        .plainGarage(SearchRequestModel.Garage.hourlyPayableParking),
                        .plainGarage(SearchRequestModel.Garage.noParking),
                    ]
                )
            }()
            sections = [section]
        }
    }
}
