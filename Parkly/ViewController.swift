//
//  ViewController.swift
//  Parkly
//
//  Created by Ben Arteaga on 5/11/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var RoundButton: RoundButton!
    
    var parkedCarAnnotation: ParkingSpot?
    
    let regionRadius: CLLocationDistance = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self as? MKMapViewDelegate
        checkLocationAuthorizationStatus()
    }

    @IBAction func parkBtnWasPressed(_ sender: RoundButton) {
        if mapView.annotations.count == 1 {
            mapView.addAnnotation(parkedCarAnnotation!)
            RoundButton.setImage(UIImage(named: "foundCar.png"), for: .normal)
        }
        else {
            mapView.removeAnnotations(mapView.annotations)
            RoundButton.setImage(UIImage(named: "parkCar.png"), for: .normal)
        }
        centerMapOnLocation(location: LocationService.instance.locationManager.location!)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            LocationService.instance.locationManager.delegate = self as? CLLocationManagerDelegate
            LocationService.instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationService.instance.locationManager.startUpdatingLocation()
        }
        else {
            LocationService.instance.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

extension ViewController: MKMapViewDelegate {
    //An MKAnnotationView is simply the view which holds the pin and the pin pop up info
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ParkingSpot {
            let identifier = "pin"
            var view: MKPinAnnotationView
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.animatesDrop = true
            view.pinTintColor = UIColor.orange
            view.calloutOffset = CGPoint(x: -8, y: -3)
            view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
            return view
        }
        else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKPinAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! ParkingSpot
        //dictionary that MapKit uses to tell Apple Maps app what type of directions we want to use
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        location.mapItem(location: (parkedCarAnnotation?.coordinate)!).openInMaps(launchOptions: launchOptions)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //passes in user location provided to us by CLLocationManagerDelegate
        centerMapOnLocation(location: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
        let locationServiceCoordinate = LocationService.instance.locationManager.location!.coordinate
        parkedCarAnnotation = ParkingSpot(title: "My Parking Spot", locationName: "Tap the 'i' for GPS", coordinate: CLLocationCoordinate2D(latitude: locationServiceCoordinate.latitude, longitude: locationServiceCoordinate.longitude))
    }
}

