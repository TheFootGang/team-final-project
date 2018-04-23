//
//  MapViewController.swift
//  Find Food Trucks SF
//
//  Created by Mark on 4/22/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let service: FoodTruckService = FoodTruckService()
    
    let manager = CLLocationManager()
    var region: MKCoordinateRegion!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.region != nil {
            mapView.setRegion(region, animated: true)
        }
        addMapAnnotations()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.02, 0.02)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        self.region = region
        self.mapView.setRegion(region, animated: false)
        self.mapView.showsUserLocation = true
    }
    
    private func addMapAnnotations() {
        service.getFoodTrucks() { [unowned self] (foodTrucks: [FoodTruck]?) in
            guard let foodTrucks = foodTrucks else {
                print("Error fetching food trucks.")
                return
            }
            
            for foodTruck in foodTrucks {
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(foodTruck.latitude, foodTruck.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = foodTruck.name
                annotation.subtitle = foodTruck.daysHours
                
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
}
    

