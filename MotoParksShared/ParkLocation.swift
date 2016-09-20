//
//  RFParkLocation.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 27/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import MapKit

class ParkLocation: NSObject, MKAnnotation {
    
    static let messageKey = "closestPark"
    
    var address: String?
    var latitude: Double!
    var longitude: Double!
    
    var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    
    init(latitude: Double, longitude: Double, address: String? = nil) {
        super.init()
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
    
    convenience init?(json: AnyObject) {
        
        guard
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double else {
                return nil
        }
        
        let address = json["address"] as? String
        self.init(latitude: latitude, longitude: longitude, address: address)
    }
    
}