//
//  ViewController.swift
//  WellingtonMotorbikeParks
//
//  Created by Rajan Fernandez on 20/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerOnLocationButton: UIBarButtonItem!
    @IBOutlet var infoButton: UIBarButtonItem!
    
    let pinReuseIdentifier = "ParkPin"
    let farParkColorAlphaComponent: CGFloat = 0.6
    let closeParkDistance: Double = 500
    
    var locationManager = CLLocationManager()
    var dataSource = ParkLocationDataSource.shared
    var lastKnownUserLocation: MKUserLocation?
    
    var locationAccessIsAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    let wellingtonRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -41.286781914499926, longitude: 174.77909061803408), span: MKCoordinateSpan(latitudeDelta: 0.03924177397755102, longitudeDelta: 0.030196408891356441))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.setRegion(wellingtonRegion, animated: false)
        
        do {
            try dataSource.loadParkLocationsIfRequiredWithDataSetNamed("parks")
        } catch {
            let alert = UIAlertController(title: "Woops...", message: "Sorry, an error occured while loading data. Please try restarting the app.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            DispatchQueue.main.async { [weak self] in
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        if let parks = dataSource.allParks {
            mapView.addAnnotations(parks)
        }
        
        // Hide the info button for now
        infoButton.tintColor = UIColor.clear
        infoButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.showsUserLocation = locationAccessIsAuthorized
    }
    
    /// Returns the distance of a given motor bike park to the users location.
    ///
    /// - Parameters:
    ///   - park: A motorbike parking location
    ///   - userLocation: The users location
    /// - Returns: The distance to the given park from the user location in metres.
    func distanceToPark(_ park: Park, from userLocation: MKUserLocation) -> Double? {
        return userLocation.location?.distance(from: park.location)
    }
    
    /// Provides a colour for map annocation views based on the distance the user is from the 
    ///
    /// - Parameters:
    ///   - park: A map
    ///   - userLocation: The users current location
    /// - Returns: A UIColor
    func colorForPark(_ park: Park, withUserLocation userLocation: MKUserLocation) -> UIColor {
        guard
            let distance = distanceToPark(park, from: userLocation),
            distance < closeParkDistance
            else { return Color.Blue.withAlphaComponent(farParkColorAlphaComponent) }

        // In the close park range, the alpha component is decreased and then guard statement above ensures that far away parks are dim on the map.
        //          ^
        // Alpha    |--__
        //          |    --__
        //          |        |
        //          |        |_____________
        //          |___________________________________
        //                   ^close park threshold      distance
        let alphaComponent = 1 - (1 - farParkColorAlphaComponent) / 4 * CGFloat(distance / closeParkDistance)
        return Color.Blue.withAlphaComponent(alphaComponent)
    }

}





