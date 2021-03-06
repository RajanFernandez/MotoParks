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
    
    static let shared = ParkLocationDataSource()
    
    private var parks: [Park]?
    
    var allParks: [Park]? { return parks }
    
    private func loadParkLocationsWithDataSetNamed(_ named: String) throws {
        
        guard let dataAsset = NSDataAsset(name: named) else {
            throw DataError.readError
        }
        
        let json = try JSONSerialization.jsonObject(with: dataAsset.data, options: [])
        
        guard let parkJSONs = (json as? [String: Any])?["parks"] as? [[String: Any]] else {
            throw DataError.readError
        }
        
        var parks = [Park]()
        for parkJSON in parkJSONs {
            if let park = Park(dictionary: parkJSON) {
                parks.append(park)
            }
        }
        
        self.parks = parks
    }
    
    func loadParkLocationsIfRequiredWithDataSetNamed(_ named: String) throws {
        guard parks == nil else { return }
        try loadParkLocationsWithDataSetNamed(named)
    }
    
    func parks(closestToUserLocation userLocation: CLLocation, numberOfParks: Int = 1, maximumDistance: Double? = nil) -> [Park]? {
        guard let parks = parks else { return nil }
        
        // If the number of requested parks is more than the total number of parks, just return all the parks.
        guard numberOfParks < parks.count else { return parks }
        
        // Calculate all the distances
        var data = [(park: Park, distance: Double)]()
        for park in parks {
            let distance = userLocation.distance(from: park.location)
            data.append((park, distance))
        }
        
        data.sort { (park1, park2) -> Bool in
            return park1.distance < park2.distance
        }
        
        let  closeParks: [Park] = data[0..<numberOfParks].map { (park) -> Park in
            return park.park
        }
        
        return closeParks
    }
    
}
