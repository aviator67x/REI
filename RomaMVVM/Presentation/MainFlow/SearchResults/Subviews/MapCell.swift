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
            let location = point.location
            let houseLocation = CLLocationCoordinate2D(
                latitude: location.coordinates[0],
                longitude: location.coordinates[1]
            )
            let annotation = MKPointAnnotation()
            annotation.coordinate = houseLocation
            annotation.title = address
            mapView.addAnnotation(annotation)
        }
        let centerNetherlandsCoordintate = CLLocationCoordinate2D(latitude: 52.1326, longitude: 5.2913)
        let coordinateRegion = MKCoordinateRegion(
            center: centerNetherlandsCoordintate,
            latitudinalMeters: 320000,
            longitudinalMeters: 160000
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
