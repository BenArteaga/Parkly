//
//  DataService.swift
//  Parkly
//
//  Created by Ben Arteaga on 5/13/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DataService {
    static let instance = DataService()
    
    private var _loadedParkingSpot = ParkingSpot(title: "", locationName: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    //carIsFound will be used for detecting if the user's car has been found when they open the app, so that if they are still searching for their car the pin will still be there
    private var _carIsFound = true
    
    //getter for _loadedParkingSpot
    var loadedParkingSpot: ParkingSpot {
        return _loadedParkingSpot
    }
    //getter for carIsFound
    var carIsFound: Bool {
        return _carIsFound
    }

    //function to save a carIsFound to disk
    func saveCarIsFound(isFound: Bool) {
        _carIsFound = isFound
        let foundData = NSKeyedArchiver.archivedData(withRootObject: _carIsFound)
        UserDefaults.standard.set(foundData, forKey: "foundKey")
        UserDefaults.standard.synchronize()
    }
    
    //function to load carIsFound from disk
    func loadCarIsFound() {
        if let foundData = UserDefaults.standard.object(forKey: "foundKey") as? Data {
            if let found = NSKeyedUnarchiver.unarchiveObject(with: foundData) as? Bool {
                _carIsFound = found
            }
        }
    }
    
    //function to set the carIsFound variable
    func setCarIsFound(isFound: Bool) {
        saveCarIsFound(isFound: isFound)
        loadCarIsFound()
    }
    
    func saveSpot(spot: ParkingSpot) {
        _loadedParkingSpot = spot
        //transform spot into data
        let spotData = NSKeyedArchiver.archivedData(withRootObject: _loadedParkingSpot)
        //saves data to a key called spot
        UserDefaults.standard.set(spotData, forKey: "spot")
        //saves data to disk
        UserDefaults.standard.synchronize()
    }
    
    func loadSpot() {
        if let spotData = UserDefaults.standard.object(forKey: "spot") as? Data {
            if let oldSpot = NSKeyedUnarchiver.unarchiveObject(with: spotData) as? ParkingSpot {
                _loadedParkingSpot = oldSpot
            }
        }
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "spotLoaded"), object: nil))
    }
    
    func dropPin(spot_in: ParkingSpot) {
        saveSpot(spot: spot_in)
        loadSpot()
    }
    
}
