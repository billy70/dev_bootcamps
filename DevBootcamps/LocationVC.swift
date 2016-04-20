//
//  LocationVC.swift
//  DevBootcamps
//
//  Created by William L. Marr III on 4/20/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    // Test addresses - remove when done.
    let addresses = [
        "3868 Center Road, Brunswick, OH 44212",        // Dunkin' Donuts
        "3675 Center Road, Brunswick, OH 44212",        // Valvoline Instant Oil Change
        "3521 Center Road, Brunswick Hills, OH 44212"   // Arby's
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        
        // Test code using test addresses - remove when done
        for address in addresses {
            getPlacemarkFromAddress(address)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func createAnnotationForLocation(location: CLLocation) {
        let bootcamp = BootcampAnnotation(coordinate: location.coordinate)
        
        mapView.addAnnotation(bootcamp)
    }
    
    func getPlacemarkFromAddress(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if let marks = placemarks where marks.count > 0 {
                if let location = marks[0].location {
                    
                    // We have a valid location with coordinates
                    self.createAnnotationForLocation(location)
                }
            }
        }
    }
}


extension LocationVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension LocationVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

extension LocationVC: MKMapViewDelegate {
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let location = userLocation.location {
            centerMapOnLocation(location)
        }
    }

    // Use this delegate method to customize the annotations.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(BootcampAnnotation) {
            
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annotationView.pinTintColor = UIColor.purpleColor()
            annotationView.animatesDrop = true
            
            return annotationView
            
        } else if annotation.isKindOfClass(MKUserLocation) {    // this is the user location - never change it's properties!
            return nil
        }
        
        return nil
    }
}
