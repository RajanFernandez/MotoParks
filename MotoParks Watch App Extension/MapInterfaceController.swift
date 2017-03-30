//
//  MapInterfaceController.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 20/08/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class MapInterfaceController: WKInterfaceController {

    @IBOutlet var mapView: WKInterfaceMap!
    
    let locationManager = CLLocationManager()
    
    var closeParks: [KMLPlacemark]? {
        didSet {
            guard let closeParks = closeParks else { return }
            mapView.removeAllAnnotations()
            closeParks.forEach { (park) in
                mapView.addAnnotation(park.location.coordinate, with: .red)
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let closeParks = context as? [KMLPlacemark] { self.closeParks = closeParks }
    }
    
    override func didAppear() {
        super.didAppear()
        update()
    }
    
    func update() {
        
        
        let session = WCSession.default()
        session.delegate = self
        session.activate()        
        session.sendMessage(
            [String : AnyObject](),
            replyHandler: { (response) in
                print(response)
//                if let closeParks = response[KMLPlacemark.messageKey] as? [KMLPlacemark] {
//                    self.closeParks = closeParks
//                }
            },
            errorHandler: { (error) in
                // handle error
                print(error)
                let action = WKAlertAction(title: "OK", style: .default, handler: {})
                self.presentAlert(withTitle: "Connection Error", message: "An error occured while communicating with you iPhone", preferredStyle: .alert, actions: [action])
        })
    }
    
    func reload(withUserLocation userLocation: CLLocation, andParkLocations parkLocations: [KMLPlacemark]) {
        mapView.removeAllAnnotations()
        
    }

}

extension MapInterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?){
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        
    }
    
}
