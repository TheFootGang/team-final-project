//
//  MapViewController.swift
//  Find Food Trucks SF
//
//  Created by Mark on 4/22/18.
//  Edited by Brandon on 4/23/18
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
        mapView.delegate = self
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
                let annotation = FoodTruckAnnotation(title: foodTruck.name, subtitle: foodTruck.daysHours, coordinate)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? FoodTruckAnnotation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -3, y: 3)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}



