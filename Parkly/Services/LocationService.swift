//
//  LocationService.swift
//  Parkly
//
//  Created by Ben Arteaga on 5/12/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService:NSObject, CLLocationManagerDelegate {
    //declaring it as static means it lives across the entire app
    static let instance = LocationService()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //CLLocationManager will update every 50 meters
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    //this function will run any time the CLLocationManager is updated
    func locationManager(manager: CLLocationManager!, didUpdateLocations location: [AnyObject]!) {
        self.currentLocation = locationManager.location?.coordinate
    }
}
