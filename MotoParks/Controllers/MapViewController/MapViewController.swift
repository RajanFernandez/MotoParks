//
//  ViewController.swift
//  WellingtonMotorbikeParks
//
//  Created by Rajan Fernandez on 20/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

enum MPError: ErrorType {
    case DataReadError
    case DataParsingError
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,  NSXMLParserDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerOnLocationButton: UIBarButtonItem!
    @IBOutlet var infoButton: UIBarButtonItem!
    var locationManager = CLLocationManager()
    
    let wellingtonRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -41.286781914499926, longitude: 174.77909061803408), span: MKCoordinateSpan(latitudeDelta: 0.03924177397755102, longitudeDelta: 0.030196408891356441))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.setRegion(wellingtonRegion, animated: false)
        
        do {
            let placemarks = try loadParkLocationsWithDataSetNamed("parks")
            mapView.performSelectorOnMainThread(#selector(MKMapView.addAnnotations(_:)), withObject: placemarks, waitUntilDone: false)
        } catch {
            let alert = UIAlertController(title: "Woops...", message: "Sorry, an error occured while loading data. Please try restarting the app.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        // Hide the info button for now
        infoButton.tintColor = UIColor.clearColor()
        infoButton.enabled = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
    }
    
    @IBAction func centerOnLocation(sender:AnyObject?) {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
        } else {
            let alert = UIAlertController(title: "Enable location services", message: "To centre the map on your location we need to know your location. Please change your location access settings.", preferredStyle: .Alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) where UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            alert.addAction(settingsAction)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(okAction)
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loadParkLocationsWithDataSetNamed(named: String) throws -> [KMLPlacemark] {
        
        guard let dataAsset = NSDataAsset(name: named) else {
            throw MPError.DataReadError
        }
        
        let kmlParser = KMLParser(kml: dataAsset.data)
        let parks = kmlParser.getPlacemarks()
        return parks
    }
    
    
    // MARK: MKMapViewDelegate
    
    // Disable annotation callouts for now.
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for view in views {
            view.canShowCallout = false
        }
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
    }
    
}

