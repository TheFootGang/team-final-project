//
//  FoodTruckDetailViewController.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 4/24/18.
//  Edited by Wagner on 5/10/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit
import MapKit

class FoodTruckDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var unwindSegueId: String!
    var foodTruck: FoodTruck!
    var region: MKCoordinateRegion!
    var locationManager = CLLocationManager()
    @IBOutlet weak var foodItemsTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var daysHoursLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func transportButtonTapped(_ sender: UIButton) {
        if let buttonText = sender.titleLabel?.text {
            switch(buttonText) {
            case "Walk": print("Clicked walk"); break;//
            case "Car": print("Clicked car"); break;
            case "Transit": print("Clicked transit"); break;
            default: print("")
            }
        }
    }
    func displayETA(directions: MKDirections) {
        directions.calculateETA(completionHandler: { response, error in
            guard let response = response else {
                return
            }
            let eta = response.expectedTravelTime
            print(eta.description)
        })
    }
    
    func displayDirectionPath(directions: MKDirections) {
        directions.calculate(completionHandler: { response, error in
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                return
            }
            let route = response.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let mapRect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(mapRect), animated: false)
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.brown
        renderer.lineWidth = 3.0
        
        return renderer
    }
    func getDirections(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, transportType: MKDirectionsTransportType) -> MKDirections {
        let sourcePlacement = MKPlacemark(coordinate: source)
        let destPlacement = MKPlacemark(coordinate: destination)
        let sourceItem = MKMapItem(placemark: sourcePlacement)
        let destItem = MKMapItem(placemark: destPlacement)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = transportType
        
        let directions = MKDirections(request: directionRequest)
        
        return directions
    }
    
    
    
    @IBAction func bookmarkButtonClicked(_ sender: UIButton) {
        if isBookmarked() {
            sender.setImage( UIImage(named:"bookmark"), for: .normal)
            removeBookmark()
        } else {
            sender.setImage(UIImage(named:"bookmarked"), for: .normal)
            bookmark()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(foodTruck.latitude, foodTruck.longitude)
        
        if self.region != nil {
            mapView.setRegion(region, animated: true)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = foodTruck.name
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = CLLocationDistance(0.5)
            locationManager.startUpdatingLocation()
        }
        
        let foodTruckCoords = CLLocationCoordinate2D(latitude: foodTruck.latitude, longitude: foodTruck.longitude)
        
        // only show directions if user allows his location
        if let userLocation = locationManager.location {
            let userCoords = userLocation.coordinate;
            let transportType = MKDirectionsTransportType.walking
            let directions = getDirections(source: userCoords, destination: foodTruckCoords, transportType: transportType)
            
            displayETA(directions: directions)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = foodTruckCoords
        mapView.addAnnotation(annotation)
        
        nameLabel.text = foodTruck.name
        daysHoursLabel.text = foodTruck.daysHours
        addressLabel.text = foodTruck.address
        locationDescriptionLabel.text = foodTruck.locationDescription
        
        // update the image to match the current bookmark state
        if isBookmarked() {
            bookmarkButton.setImage(UIImage(named:"bookmarked"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named:"bookmark"), for: .normal)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.02, 0.02)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        self.region = region
        self.mapView.setRegion(region, animated: false)
    }
    
    
    // Returns whether the bookmark is stored in UserDefaults
    func isBookmarked() -> Bool {
        if(UserDefaults.standard.object(forKey: "\(foodTruck.id)") != nil) {
            return true
        }
        return false
    }
    
    // Store bookmark for this truck as a <Key, Value> pair into UserDefaults
    // @Key: id of the food truck
    // @Value: empty string
    func bookmark() {
        UserDefaults.standard.set("", forKey: "\(foodTruck.id)")
    }
    
    // Remove this bookmark from UserDefaults
    func removeBookmark() {
        UserDefaults.standard.removeObject(forKey: "\(foodTruck.id)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTruck.foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath)
        cell.textLabel?.text = foodTruck.foodItems[indexPath.row].capitalized
        cell.textLabel?.font = UIFont(name: "Futura", size: 17)
        return cell
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: unwindSegueId, sender: self)
    }
    
}

