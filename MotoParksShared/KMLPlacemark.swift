//
//  KMLPlacemark.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import MapKit

class KMLPlacemark: NSObject {
    
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
    
}

extension KMLPlacemark: MKAnnotation {
    
    var title: String? { return name }
    
    var coordinate: CLLocationCoordinate2D { return location.coordinate }
    
}
