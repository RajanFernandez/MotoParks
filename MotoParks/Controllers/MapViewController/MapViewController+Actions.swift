//
//  MapViewController+Actions.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 5/04/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import UIKit

extension MapViewController {
    
    @IBAction func centerOnLocation(_ sender:AnyObject?) {
        if locationAccessIsAuthorized {
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
    
}
