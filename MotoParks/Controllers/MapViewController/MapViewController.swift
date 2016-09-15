//
//  ViewController.swift
//  WellingtonMotorbikeParks
//
//  Created by Rajan Fernandez on 20/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

enum MPError: Error {
    case dataReadError
    case dataParsingError
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,  XMLParserDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerOnLocationButton: UIBarButtonItem!
    @IBOutlet var infoButton: UIBarButtonItem!
    
    let pinReuseIdentifier = "ParkPin"
    
    var locationManager = CLLocationManager()
    
    let wellingtonRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -41.286781914499926, longitude: 174.77909061803408), span: MKCoordinateSpan(latitudeDelta: 0.03924177397755102, longitudeDelta: 0.030196408891356441))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.setRegion(wellingtonRegion, animated: false)
        
        do {
            let placemarks = try loadParkLocationsWithDataSetNamed("parks")
            mapView.performSelector(onMainThread: #selector(MKMapView.addAnnotations(_:)), with: placemarks, waitUntilDone: false)
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
    
    func loadParkLocationsWithDataSetNamed(_ named: String) throws -> [KMLPlacemark] {
        
        guard let dataAsset = NSDataAsset(name: named) else {
            throw MPError.dataReadError
        }
        
        let kmlParser = KMLParser(kml: dataAsset.data)
        let parks = kmlParser.getPlacemarks()
        return parks
    }
    
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ParkLocation else { return nil }
        var view: MKPinAnnotationView
        if let reuseableView = mapView.dequeueReusableAnnotationView(withIdentifier: pinReuseIdentifier) as? MKPinAnnotationView {
            view = reuseableView
            view.annotation = annotation
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinReuseIdentifier)
        }
        view.pinTintColor = Color.Blue
        return view
    }
    
    // Disable annotation callouts for now.
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            view.canShowCallout = false
        }
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
}

