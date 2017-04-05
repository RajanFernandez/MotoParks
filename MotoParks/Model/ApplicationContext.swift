//
//  ApplicationContext.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 31/03/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import MapKit

let LocationManagerIsAuthorised = "LocationManagerIsAuthorised"

class ApplicationContext: NSObject {
    
    static let Key: String = "ApplicationContextKey"
    
    let userLocation: CLLocation
    var parks: [Park]
    
    init(userLocation: CLLocation, parks: [Park]) {
        self.userLocation = userLocation
        self.parks = parks
    }
    
    init?(applicationContext: [String: Any]) {
        guard
            let latitude = applicationContext[Keys.userLocationLatitude] as? Double,
            let longitude = applicationContext[Keys.userLocationLongitude] as? Double
            else { return nil }
        
        self.userLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        var parks = [Park]()
        if let parksArray = applicationContext[Keys.parks] as? [[String: Any]] {
            for parkDict in parksArray {
                if let park = Park(dictionary: parkDict) {
                    parks.append(park)
                }
            }
        }
        self.parks = parks
    }
    
    // MARK: NSCoding
    
    private struct Keys {
        static let userLocationLatitude: String = "UserLocationLatitude"
        static let userLocationLongitude: String = "UserLocationLongitude"
        static let parks: String = "Parks"
    }
    
    var messagePayload: [String: Any] {
        var dict = [String: Any]()
        dict[Keys.userLocationLatitude] = userLocation.coordinate.latitude
        dict[Keys.userLocationLongitude] = userLocation.coordinate.longitude
        
        if parks.count > 0 {
            var parksArray = [Any]()
            for park in parks {
                parksArray.append(park.dictionary)
            }
            dict[Keys.parks] = parksArray
        }
        
        return dict
    }
    
}
