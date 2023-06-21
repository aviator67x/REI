//
//  MapCellModel.swift
//  RomaMVVM
//
//  Created by User on 25.04.2023.
//

import Foundation
import MapKit
import CoreLocation

final class MapCell: UICollectionViewListCell {
    let mapView = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(mapView) {
            let screenRect = UIScreen.main.bounds
            let screenHeight = screenRect.size.height
            $0.height.equalTo(screenHeight)
            $0.edges.equalToSuperview()
        }
    }
    
    func setup(with model: MapCellModel) {
        model.points.forEach { point in
            let address = point.address
            guard let location = point.location else {
                return
            }
            let houseLocation = CLLocationCoordinate2D(
                latitude: location.coordinates[0],
                longitude: location.coordinates[1]
            )
            let annotation = MKPointAnnotation()
            annotation.coordinate = houseLocation
            annotation.title = address
            mapView.addAnnotation(annotation)
        }
    }
}
