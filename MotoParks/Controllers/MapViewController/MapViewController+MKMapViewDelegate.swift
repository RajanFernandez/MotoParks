//
//  MapViewController+MKMapViewDelegate.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 5/04/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let park = annotation as? Park else { return nil }
        
        var view: MKAnnotationView
        if let reuseableView = mapView.dequeueReusableAnnotationView(withIdentifier: pinReuseIdentifier) {
            view = reuseableView
            view.annotation = park
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: pinReuseIdentifier)
        }
        
        view.image = UIImage(named: "park")
        view.alpha = alpha(for: park, withUserLocation: mapView.userLocation)
        return view
    }
    
    // Disable annotation callouts for now.
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { (view) in view.canShowCallout = false }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let newUserLocation = userLocation.location else { return }
        
        // Ensure the user location is shown on top of the other annotations.
        if let currentLocationAnnotationView = mapView.view(for: mapView.userLocation) {
            currentLocationAnnotationView.superview?.bringSubviewToFront(currentLocationAnnotationView)
        }
        
        // Only rerender pins if the user has moved a significant distance.
        if
            let lastKnownUserLocation = lastKnownUserLocation?.location,
            lastKnownUserLocation.distance(from: newUserLocation) < 50
        { return }
        
        // Save the users new location
        lastKnownUserLocation = userLocation
        
        // Recolor the annotations
        for annotation in mapView.annotations {
            guard let park = annotation as? Park else { continue }
            let view = mapView.view(for: annotation)
            view?.alpha = alpha(for: park, withUserLocation: mapView.userLocation)
        }
        
        // Update the application context for the watch app
        guard let userLocation = userLocation.location else { return }
        let closeParks = dataSource.parks(closestToUserLocation: userLocation, numberOfParks: 10, maximumDistance: 500) ?? [Park]()
        let applicationContext = ApplicationContext(userLocation: userLocation, parks: closeParks)
        do {
            try WatchSessionManager.shared.updateApplicationContext(applicationContext.messagePayload)
        } catch {
            // Do not catch any errors here as there's not much we can do with them.
        }
    }
    
}
