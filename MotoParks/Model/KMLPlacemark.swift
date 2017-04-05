//
//  KMLPlacemark.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import MapKit

class KMLPlacemark: NSObject, NSCoding {
    
    var name: String?
    var location: CLLocation
    
    init(latitude: Double, longitude: Double, name: String? = nil) {
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.name = name
        super.init()
    }
    
    override var description: String {
        return "KMLPlacemark: \(name), \(location)"
    }
    
    // MARK: NSCoding
    
    private struct Keys {
        static let name: String = "Name"
        static let userLocationLatitude: String = "UserLocationLatitude"
        static let userLocationLongitude: String = "UserLocationLongitude"
    }
    
    required init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Keys.name) as! String
        let latitude = aDecoder.decodeDouble(forKey: Keys.userLocationLatitude)
        let longitude = aDecoder.decodeDouble(forKey: Keys.userLocationLongitude)
        self.name = name
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: Keys.name)
        aCoder.encode(self.location.coordinate.latitude, forKey: Keys.userLocationLatitude)
        aCoder.encode(self.location.coordinate.longitude, forKey: Keys.userLocationLongitude)
    }
    
}

extension KMLPlacemark: MKAnnotation {
    
    var title: String? { return name }
    
    var coordinate: CLLocationCoordinate2D { return location.coordinate }
    
}
