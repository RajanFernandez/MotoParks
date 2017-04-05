//
//  MapInterfaceController.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 20/08/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import WatchKit
import WatchConnectivity
import CoreLocation
import Foundation

class MapInterfaceController: WKInterfaceController {

    @IBOutlet var mapView: WKInterfaceMap!
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.setTitle("Nearby parks")
        WatchSessionManager.shared.delegate = self
        locationManager.delegate = self
    }
    
    @IBAction func refreshMenuAction() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        guard CLLocationManager.authorizationStatus() == .authorizedAlways else {
            DispatchQueue.main.async { [unowned self] in
                let okAction = WKAlertAction(title: "OK", style: .default, handler: { })
                self.presentAlert(withTitle: "Authorisation Error", message: "To display your location and closest parks, ensure the MotoParks app on your iPhone has Always Allow location access in the Settings app.", preferredStyle: .alert, actions: [okAction])
            }
            return
        }
        
        locationManager.requestLocation()
    }
    
    func mapRegion(withUserLocation userLocation: CLLocation, andParks closeParks: [Park]?) -> MKCoordinateRegion {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        return region
    }
    
}

extension MapInterfaceController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        // Ask the phone for parks nearby
        WatchSessionManager.shared.requestParks(forUserLocation: userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [unowned self] in
            let okAction = WKAlertAction(title: "OK", style: .default, handler: { })
            self.presentAlert(withTitle: "Failed to determine your location", message: "Please ensure you have location services enabled and try again", preferredStyle: .alert, actions: [okAction])
        }
    }
    
}

extension MapInterfaceController: WatchSessionManagerDelegate {
    
    func update(with userLocation: CLLocation, andParks parks: [Park]? = nil) {
        DispatchQueue.main.async { [unowned self] in
            // Clear the map
            self.mapView.removeAllAnnotations()
            
            // User location
            self.mapView.addAnnotation(userLocation.coordinate, with: #imageLiteral(resourceName: "userlocation"), centerOffset: CGPoint(x: 0, y: 0))
            
            // Park locations
            if let parks = parks {
                for park in parks {
                    self.mapView.addAnnotation(park.coordinate, with: #imageLiteral(resourceName: "park"), centerOffset: CGPoint(x: 0, y: 0))
                }
            }
            
            // Set the displayed region
            let region = self.mapRegion(withUserLocation: userLocation, andParks: parks)
            self.mapView.setRegion(region)
        }
    }
    
    func update(with error: Error) {
        // Default error alert
        DispatchQueue.main.async { [unowned self] in
            let okAction = WKAlertAction(title: "OK", style: .default, handler: { })
            self.presentAlert(withTitle: "Error", message: "An error occured while communicating with your iPhone", preferredStyle: .alert, actions: [okAction])
        }
    }
    
}
