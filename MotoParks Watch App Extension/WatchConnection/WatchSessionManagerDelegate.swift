//
//  WatchSessionManagerDelegate.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 31/03/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation
import MapKit

protocol WatchSessionManagerDelegate: class {
    
    func update(with error: Error)
    
    func update(with userLocation: CLLocation, andParks parks: [Park]?)
    
}
