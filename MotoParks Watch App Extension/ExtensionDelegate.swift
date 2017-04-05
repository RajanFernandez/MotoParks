//
//  ExtensionDelegate.swift
//  MotoParks Watch App Extension
//
//  Created by Rajan Fernandez on 21/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import WatchKit
import MapKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        WatchSessionManager.shared.configureAndActivateSession()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
