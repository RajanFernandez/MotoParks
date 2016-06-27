//
//  ViewController.swift
//  WellingtonMotorbikeParks
//
//  Created by Rajan Fernandez on 20/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerOnLocationButton: UIBarButtonItem!
    var locationManager = CLLocationManager()
    
    let wellingtonRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -41.293168547236348, longitude: 174.77885395592267), span: MKCoordinateSpan(latitudeDelta: 0.046173607176569931, longitudeDelta: 0.03553390886759189))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.setRegion(wellingtonRegion, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func centerOnLocation(sender:AnyObject?) {
        
    }
    
    func loadParkLocationsWithDataSetNamed(named: String) -> [ParkLocation] {
        var parks = [ParkLocation]()
        return parks
    }

}

