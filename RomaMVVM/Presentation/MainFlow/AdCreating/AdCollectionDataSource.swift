//
//  AdCollectionDataSource.swift
//  RomaMVVM
//
//  Created by User on 17.05.2023.
//

import Foundation
import UIKit

final class AdCollectionDataSource: NSObject, UICollectionViewDataSource {
    let dataSource: [AdCollectionModel] = [.address, .propertyType, .year, .photo]
    
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
        case .address:
            let cell: AddressCell = collectionView.dedequeueReusableCell(for: indexPath)
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
