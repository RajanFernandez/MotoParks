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
    
    var closestPark: ParkLocation? {
        didSet {
            guard let closestPark = closestPark else { return }
            mapView.removeAllAnnotations()
            mapView.addAnnotation(closestPark.coordinate, with: .red)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let closestPark = context as? ParkLocation { self.closestPark = closestPark }
    }
    
    override func didAppear() {
        super.didAppear()
        updateClosestPark()
    }
    
    func updateClosestPark() {
        let session = WCSession.default()
        session.delegate = self
        session.activate()
        session.sendMessage(
            [String : AnyObject](),
            replyHandler: { (response) in
                if let closestPark = response[ParkLocation.messageKey] as? ParkLocation {
                    self.closestPark = closestPark
                }
            },
            errorHandler: { (error) in
                // handle error
        })
    }

}

extension MapInterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?){
        
    }
    
}
