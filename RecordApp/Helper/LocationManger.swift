//
//  LocationManger.swift
//  RecordApp
//
//  Created by se-ryeong on 1/12/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    @Published var userLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    static let shared = LocationManager(accuracy: kCLLocationAccuracyHundredMeters)
    
    init(accuracy: CLLocationAccuracy) {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = accuracy
    }
    
    func requestPermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
}

// delegae
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways ||
            manager.authorizationStatus == .authorizedWhenInUse {
            self.locationManager.requestLocation()
        }
    }
}
