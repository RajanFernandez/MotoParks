//
//  MapViewController+CLLocationManagerDelegate.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 5/04/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import CoreLocation

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
}
