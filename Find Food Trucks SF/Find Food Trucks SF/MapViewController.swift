//
//  MapViewController.swift
//  Find Food Trucks SF
//
//  Created by Mark on 4/22/18.
//  Edited by Brandon on 4/23/18
//  Edited by Stanley on 5/9/18
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func unwindToMapViewFromDetail(segue:UIStoryboardSegue) {}
    
    var foodTrucks: [FoodTruck] = []
    
    let defaultRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpanMake(0.02, 0.02))
    
    let service: FoodTruckService = FoodTruckService()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        mapView.register(FoodTruckMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(FoodTruckClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
        }
        
        addMapAnnotations()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = CLLocationDistance(1)
            locationManager.startUpdatingLocation()
        } else {
            mapView.setRegion(defaultRegion, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinates, span)
        self.mapView.setRegion(region, animated: false)
    }
    
    private func addMapAnnotations() {
        service.getFoodTrucks() { [unowned self] (foodTrucks: [FoodTruck]?) in
            guard let foodTrucks = foodTrucks else {
                print("Error fetching food trucks.")
                return
            }
            
            self.foodTrucks = foodTrucks
            
            for foodTruck in self.foodTrucks {
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(foodTruck.latitude, foodTruck.longitude)
                let annotation = FoodTruckAnnotation(id: foodTruck.id, title: foodTruck.name, subtitle: foodTruck.daysHours, coordinate)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "mapToDetailSegueId", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapToDetailSegueId") {
            let vc = segue.destination as! FoodTruckDetailViewController
            
            guard
                let annotationView = sender as? MKAnnotationView,
                let annotation = annotationView.annotation as? FoodTruckAnnotation,
                let id = annotation.id,
                let foodTruck = self.foodTrucks.first(where: { $0.id == id })
                else {
                    print("Error")
                    return
            }
            
            // pass data to new vc
            vc.foodTruck = foodTruck
            vc.unwindSegueId = "unwindToMapViewSegueId"
        }
    }
}



