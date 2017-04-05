//
//  WatchSessionManager.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 31/03/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation
import MapKit
import WatchConnectivity

class WatchSessionManager: NSObject {
    
    static let shared = WatchSessionManager()
    
    func configureAndActivateSession() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default()
        session.delegate = self;
        session.activate()
    }

    func updateApplicationContext(_ context: [String : Any]) throws {
        let session = WCSession.default()
        // If a phone is not paired to a watch, or the watch app is not installed, we can consider the session invalid and not both sending any data to the watch.
        guard session.isPaired && session.isWatchAppInstalled else { return }
        try session.updateApplicationContext(context)
    }
    
}

extension WatchSessionManager: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // No action required
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // No action required
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // No action required
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        guard let applicationContext = ApplicationContext(applicationContext: message) else {
            // TODO: Send some error here.
            replyHandler(message)
            return
        }
        
        if let parks = ParkLocationDataSource.shared.parks(closestToUserLocation: applicationContext.userLocation, numberOfParks: 10, maximumDistance: 700) {
            applicationContext.parks = parks
        }
        
        replyHandler(applicationContext.messagePayload)
    }
    
}

