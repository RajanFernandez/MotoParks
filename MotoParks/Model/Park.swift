//
//  Park.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 5/04/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import MapKit

class Park: NSObject {
    
    var name: String?
    var location: CLLocation
    
    private struct Keys {
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
        static let name: String = "name"
    }
    
    init(location: CLLocation, name: String? = nil) {
        self.name = name
        self.location = location
        super.init()
    }
    
    init?(dictionary: [String: Any]) {
        guard
            let latitude = dictionary[Keys.latitude] as? Double,
            let longitude = dictionary[Keys.longitude] as? Double
            else { return nil }
        
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.name = dictionary[Keys.name] as? String
    }
    
    var dictionary: [String: Any] {
        var dictionary: [String: Any] = [
            Keys.latitude: location.coordinate.latitude,
            Keys.longitude: location.coordinate.longitude,
        ]
        if let name = name {
            dictionary[Keys.name] = name
        }
        return dictionary
    }
    
}

extension Park: MKAnnotation {
    
    var title: String? { return name }
    
    var coordinate: CLLocationCoordinate2D { return location.coordinate }
    
}
