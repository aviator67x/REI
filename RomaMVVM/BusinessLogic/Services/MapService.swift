//
//  MapService.swift
//  RomaMVVM
//
//  Created by User on 02.06.2023.
//

import Foundation
import MapKit

protocol MapService {
    func showOnMap(mapView: MKMapView, address: String, region: Double)
    func showOnMap(mapView: MKMapView, location: Location, address: String)
}

final class MapServiceImpl: MapService {
    func showOnMap(mapView: MKMapView, address: String, region: Double) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { placemarks, error in
            if error != nil {
                print("Failed to retrieve location")
                return
            }
            var location: CLLocation?
            if let placemarks = placemarks, !placemarks.isEmpty {
                location = placemarks.first?.location
            }
            guard let location = location else {
                return
            }

            let houseLocation = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )

            let annotation = MKPointAnnotation()
            annotation.coordinate = houseLocation
            annotation.title = address
            let coordinateRegion = MKCoordinateRegion(
                center: annotation.coordinate,
                latitudinalMeters: region,
                longitudinalMeters: region
            )
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.addAnnotation(annotation)
        })
    }

    func showOnMap(mapView: MKMapView, location: Location, address: String) {
        let houseLocation = CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude
        )

        let annotation = MKPointAnnotation()
        annotation.coordinate = houseLocation
        annotation.title = address
        let coordinateRegion = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
}
