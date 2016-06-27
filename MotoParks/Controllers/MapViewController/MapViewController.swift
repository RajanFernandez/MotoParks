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
        
        do {
            let parks = try loadParkLocationsWithDataSetNamed("parks")
            mapView.performSelectorOnMainThread(#selector(MKMapView.addAnnotations(_:)), withObject: parks, waitUntilDone: false)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func centerOnLocation(sender:AnyObject?) {
        
    }
    
    func loadParkLocationsWithDataSetNamed(named: String) throws -> [ParkLocation] {
        
        guard let dataAsset = NSDataAsset(name: named) else {
            throw MPError.DataReadError
        }
        
        var json: AnyObject
        do {
            json = try NSJSONSerialization.JSONObjectWithData(dataAsset.data, options: .MutableContainers)
        } catch {
            throw MPError.DataParsingError
        }
        
        var parks = [ParkLocation]()
        if let jsonParks = json["parks"] as? [AnyObject] {
            for jsonPark in jsonParks {
                if let park = ParkLocation(json: jsonPark) {
                    parks.append(park)
                }
            }
        } else {
            throw MPError.DataParsingError
        }

        return parks
    }

}

