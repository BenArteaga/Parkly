//
//  ParkingSpot.swift
//  Parkly
//
//  Created by Ben Arteaga on 5/11/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class ParkingSpot: NSObject, MKAnnotation, NSCoding {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return locationName
    }
    
    //A CLLocationCoordinate2D is simply a GPS coordinate with a longtitude and latitude property
    func mapItem(location: CLLocationCoordinate2D) -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: location, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "titleKey") as? String
        locationName = aDecoder.decodeObject(forKey: "locationKey") as? String
        let latitude = aDecoder.decodeDouble(forKey: "latitudeKey")
        let longitude = aDecoder.decodeDouble(forKey: "longitudeKey")
        coordinate = CLLocationCoordinate2D(latitude: latitude , longitude: longitude )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "titleKey")
        aCoder.encode(locationName, forKey: "locationKey")
        aCoder.encode(coordinate.latitude, forKey: "latitudeKey")
        aCoder.encode(coordinate.longitude, forKey: "longitudeKey")
    }
}

//extension ParkingSpot {
//    convenience init(dict: [String: AnyObject]) {
//        self.init(title: dict["titleKey"] as! String, locationName: dict["locationKey"] as! String, coordinate: dict["coordinateKey"] as! CLLocationCoordinate2D)
//    }
//
//    //function to turn a parking spot into a dictionary so that it can be stored into User Defaults via NSDictionary
//    func toDic() -> [String: AnyObject] {
//        var dic = [String: AnyObject] ()
//        dic["titleKey"] = title as AnyObject
//        dic["locationKey"] = locationName as AnyObject
//        dic["coordinateKey"] = coordinate as AnyObject
//        return dic
//    }
//}
