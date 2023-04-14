//
//  LocationViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-22.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var coordinate = CLLocationCoordinate2D(
        latitude: 49.2577143, longitude: -123.1939435)
    
    override init() {
      super.init()

      self.locationManager.delegate = self
      self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = kCLDistanceFilterNone
      self.locationManager.requestWhenInUseAuthorization()
      self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else{
            return
        }
        self.location = location
        self.coordinate = location.coordinate
    }
}
