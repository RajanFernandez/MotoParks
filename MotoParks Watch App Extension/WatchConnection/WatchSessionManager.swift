//
//  WatchSessionManager.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 31/03/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class WatchSessionManager: NSObject {
    
    static let shared = WatchSessionManager()
    
    weak var delegate: WatchSessionManagerDelegate?
    
    func configureAndActivateSession() {
        let session = WCSession.default()
        session.delegate = self
        session.activate()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            CLLocationManager().requestAlwaysAuthorization()
        }
    }
    
    func requestParks(forUserLocation userLocation: CLLocation) {
        
        // The session must be reachable to use sendMessage:replyHandler:errorHandler
        guard WCSession.default().isReachable else { return }
        
        // Send the user location in an application context to the phone.
        let applicationContext = ApplicationContext(userLocation: userLocation, parks: [Park]())
        WCSession.default().sendMessage(applicationContext.messagePayload,
                                        replyHandler:
            { [unowned self] (reply) in
                self.didRecieveReply(reply)
            },
                                        errorHandler:
            { [unowned self] (error) in
                self.didRecieveError(error)
        })
    }

    func didRecieveReply(_ reply: [String: Any]) {
        // The reply here should be the application context that was send, but with the closest parks added.
        
        guard let applicationContext = ApplicationContext(applicationContext: reply) else {
            delegate?.update(with: WatchConnectionError.unusableMessagePayload)
            return
        }
        
        delegate?.update(with: applicationContext.userLocation, andParks: applicationContext.parks)
    }
    
    func didRecieveError(_ error: Error) {
        delegate?.update(with: error)
    }
    
}

extension WatchSessionManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // No action required.
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        guard let applicationContext = ApplicationContext(applicationContext: applicationContext) else {
            delegate?.update(with: WatchConnectionError.unusableMessagePayload)
            return
        }
        
        delegate?.update(with: applicationContext.userLocation, andParks: applicationContext.parks)
    }
    
}
