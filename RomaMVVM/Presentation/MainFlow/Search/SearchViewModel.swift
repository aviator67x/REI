//
//  SearchViewModel.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine

struct SearchCollection {
    let sections: SearchSection
    let items: [SearchItem]
}

final class SearchViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchTransition, Never>()

    @Published var screenConfiguration = 0
    @Published private(set) var sections: [SearchCollection] = []

    override init() {
        super.init()
    }

    override func onViewDidLoad() {
        updateDataSource()
    }

    func configureScreen(for index: Int) {
        screenConfiguration = index
    }

    private func updateDataSource() {
        let segmentControlSection: SearchCollection = {
            SearchCollection(sections: .segmentControl, items: [.segmentControl])
        }()

        let distanceSection: SearchCollection = {
            SearchCollection(
                sections: .distance,
                items: [
                    .distance("+ 1"),
                    .distance("+ 2"),
                    .distance("+ 5"),
                    .distance("+ 10"),
                    .distance("+ 15"),
                    .distance("+ 30"),
                    .distance("+ 50"),
                    .distance("+ 100"),
                ]
            )
        }()

        let priceSection: SearchCollection = {
            SearchCollection(sections: .price, items: [.price])
        }()

        let yearSection: SearchCollection = {
            SearchCollection(sections: .year, items: [.year])
        }()

        let garageSection: SearchCollection = {
            SearchCollection(sections: .garage, items: [.garage])
        }()

        sections = [segmentControlSection, distanceSection, priceSection, yearSection, garageSection]
    }
}
