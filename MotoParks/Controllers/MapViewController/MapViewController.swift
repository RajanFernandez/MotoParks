//
//  ViewController.swift
//  WellingtonMotorbikeParks
//
//  Created by Rajan Fernandez on 20/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,  XMLParserDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerOnLocationButton: UIBarButtonItem!
    @IBOutlet var infoButton: UIBarButtonItem!
    
    let pinReuseIdentifier = "ParkPin"
    let closeParkDistance: Double = 500
    
    var locationManager = CLLocationManager()
    var dataSource = ParkLocationDataSource()
    
    let wellingtonRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -41.286781914499926, longitude: 174.77909061803408), span: MKCoordinateSpan(latitudeDelta: 0.03924177397755102, longitudeDelta: 0.030196408891356441))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.setRegion(wellingtonRegion, animated: false)
        
        do {
            try dataSource.loadParkLocationsWithDataSetNamed("parks")
            mapView.performSelector(onMainThread: #selector(MKMapView.addAnnotations(_:)),
                                    with: dataSource.allParks,
                                    waitUntilDone: false)
        } catch {
            let alert = UIAlertController(title: "Woops...", message: "Sorry, an error occured while loading data. Please try restarting the app.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            DispatchQueue.main.async { [weak self] in
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        // Hide the info button for now
        infoButton.tintColor = UIColor.clear
        infoButton.isEnabled = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    @IBAction func centerOnLocation(_ sender:AnyObject?) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        } else {
            let alert = UIAlertController(title: "Enable location services", message: "To centre the map on your location we need to know your location. Please change your location access settings.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) , UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            })
            alert.addAction(settingsAction)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            DispatchQueue.main.async { [weak self] in
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /// Returns the distance of a given motor bike park to the users location.
    ///
    /// - Parameters:
    ///   - park: A motorbike parking location
    ///   - userLocation: The users location
    /// - Returns: The distance to the given park from the user location in metres.
    func distanceToPark(_ park: KMLPlacemark, from userLocation: MKUserLocation) -> Double? {
        return userLocation.location?.distance(from: park.location)
    }
    
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let park = annotation as? KMLPlacemark else { return nil }
        
        var view: MKPinAnnotationView
        if let reuseableView = mapView.dequeueReusableAnnotationView(withIdentifier: pinReuseIdentifier) as? MKPinAnnotationView {
            view = reuseableView
            view.annotation = park
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinReuseIdentifier)
        }
        
        if
            let distance = distanceToPark(park, from: mapView.userLocation),
            distance < closeParkDistance
        {
            view.pinTintColor = Color.Blue
        } else {
            view.pinTintColor = Color.Blue.withAlphaComponent(0.6)
        }
        return view
    }
    
    // Disable annotation callouts for now.
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { (view) in view.canShowCallout = false }
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let parks = dataSource.allParks else { return }
        // Refresh the annotations to recolour the pins
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(parks)
    }
    
}

