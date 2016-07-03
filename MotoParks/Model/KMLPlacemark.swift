//
//  KMLPlacemark.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import MapKit

class KMLPlacemark: NSObject, MKAnnotation {
    
    var name: String?
    var coordinate: CLLocationCoordinate2D
    
    var title: String? { return name }
    
    init(latitude: Double, longitude: Double, name: String? = nil) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.name = name
        super.init()
    }
    
    override var description: String {
        return "KMLPlacemark: \(name), \(coordinate)"
    }
    
}