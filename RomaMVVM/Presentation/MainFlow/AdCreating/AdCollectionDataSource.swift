//
//  AdCollectionDataSource.swift
//  RomaMVVM
//
//  Created by User on 17.05.2023.
//

import Foundation
import UIKit
import Combine

enum AdCollectionDataSourceAction {
    case ort(String)
    case street(String)
    case house(String)
}

final class AdCollectionDataSource: NSObject, UICollectionViewDataSource {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdCollectionDataSourceAction, Never>()

    private lazy var cancellables = Set<AnyCancellable>()

    private(set) var dataSource: [AdCollectionModel] = [.address(model: .init()), .propertyType, .year, .photo]
    
    func updateDataSource(with model: AddressCellModel) {
        self.dataSource = [.address(model: model), .propertyType, .year, .photo]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = dataSource[indexPath.section]
        switch section {
        case .address(let value):
            let cell: AddressCell = collectionView.dedequeueReusableCell(for: indexPath)
            cell.actionPublisher
                .sinkWeakly(self, receiveValue: { (self, value) in
                    switch value {
                    case .ort(let ort):
                        self.actionSubject.send(.ort(ort))
                    case .street(let street):
                        self.actionSubject.send(.street(street))
                    case .house(let house):
                        self.actionSubject.send(.house(house))
                    }
                })
                .store(in: &cell.cancellables)
            cell.setupCell(with: value)
            return cell

        case .propertyType:
            let cell: PropertyTypeCell = collectionView.dedequeueReusableCell(for: indexPath)
            return cell

        case .year:
            let cell: YearCell = collectionView.dedequeueReusableCell(for: indexPath)
            return cell

        case .photo:
            let cell: PictureCell = collectionView.dedequeueReusableCell(for: indexPath)
            return cell
        }
    }
}
