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

class MapViewController: UIViewController, MKMapViewDelegate, NSXMLParserDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerOnLocationButton: UIBarButtonItem!
    var locationManager = CLLocationManager()
    
    let wellingtonRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -41.286781914499926, longitude: 174.77909061803408), span: MKCoordinateSpan(latitudeDelta: 0.03924177397755102, longitudeDelta: 0.030196408891356441))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
    }
    
    @IBAction func centerOnLocation(sender:AnyObject?) {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
        } else {
            let alert = UIAlertController(title: "Enable location services", message: "To centre the map on your location we need to know your location. Please change your location privacy settings in the settings app.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
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
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region)
    }
    
}

