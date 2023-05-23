//
//  AdMultiDetailsViewModel.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import Combine

final class AdMultiDetailsViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdMultiDetailsTransition, Never>()

    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private lazy var sectionsSubject = CurrentValueSubject<[AdMultiDetailsCollection], Never>([])

    let model: AdCreatingModel
    let screenState: AdMultiDetailsScreenState

    init(model: AdCreatingModel, screenState: AdMultiDetailsScreenState) {
        self.model = model
        self.screenState = screenState
        super.init()
    }

    override func onViewDidLoad() {
        createDataSource()
    }

    func updateAdCreatingModel(for item: AdMultiDetailsItem) {
        model.updateAdCreatingRequestModel(with: item)
        transitionSubject.send(.popScreen)
    }

    func popScreen() {
        transitionSubject.send(.popScreen)
    }
}

// MARK: - extension

private extension AdMultiDetailsViewModel {
    func createDataSource() {
        switch screenState {
        case .year:
            let section: AdMultiDetailsCollection = {
                AdMultiDetailsCollection(
                    section: .plain,
                    items: [.yearPicker(2000)]
                )
            }()
            sectionsSubject.value = [section]

        case .garage:
            let section: AdMultiDetailsCollection = {
                AdMultiDetailsCollection(
                    section: .plain,
                    items: [
                        .garage(.garage),
                        .garage(.freeParking),
                        .garage(.municipalParking),
                        .garage(.hourlyPayableParking),
                        .garage(.noParking),
                    ]
                )
            }()
            sectionsSubject.value = [section]

        case .type:
            let section: AdMultiDetailsCollection = {
                AdMultiDetailsCollection(
                    section: .plain,
                    items: [
                        .type(.house),
                        .type(.apartment),
                        .type(.land),
                    ]
                )
            }()
            sectionsSubject.value = [section]

        case .number:
            let section: AdMultiDetailsCollection = {
                AdMultiDetailsCollection(
                    section: .plain,
                    items: [
                        .number(.one),
                        .number(.two),
                        .number(.three),
                        .number(.four),
                        .number(.five),
                    ]
                )
            }()
            sectionsSubject.value = [section]
        }
    }
}
