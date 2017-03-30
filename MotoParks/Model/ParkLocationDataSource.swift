//
//  ParkLocationDataSource.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 30/03/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

class ParkLocationDataSource {
    
    private var parks: [KMLPlacemark]?
    
    var allParks: [KMLPlacemark]? { return parks }
    
    func loadParkLocationsWithDataSetNamed(_ named: String) throws {
        
        guard let dataAsset = NSDataAsset(name: named) else {
            throw DataError.readError
        }
        
        parks = KMLParser().placemarks(fromKML: dataAsset.data)
    }
    
    func parks(closestToUserLocation userLocation: CLLocation, numberOfParks: Int = 1) -> [KMLPlacemark]? {
        guard let parks = parks else { return nil }
        
        // If the number of requested parks is more than the total number of parks, just return all the parks.
        guard numberOfParks < parks.count else { return parks }
        
        // Calculate all the distances
        var data = [(park: KMLPlacemark, distance: Double)]()
        for park in parks {
            let distance = userLocation.distance(from: park.location)
            data.append((park, distance))
        }
        
        data.sort { (park1, park2) -> Bool in
            return park1.distance < park2.distance
        }
        
        let  closeParks: [KMLPlacemark] = data[0..<numberOfParks].map { (park) -> KMLPlacemark in
            return park.park
        }
        
        return closeParks
    }
    
}
