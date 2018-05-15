//
//  FoodTruckDetailViewController.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 4/24/18.
//  Edited by Wagner on 5/10/18.
//  Edited by Stanley on 5/11/18
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit
import MapKit

enum TransportType: Int {
    case Walk
    case Car
}

class FoodTruckDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    let defaultRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpanMake(0.02, 0.02))
    let bookmarksManager: BookmarksManager = BookmarksManager()
    var foodTruck: FoodTruck!
    var region: MKCoordinateRegion!
    var locationManager = CLLocationManager()
    var currentTransportType: MKDirectionsTransportType = .walking
    var lastTransportButtonTapped: UIButton?
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var carTransportButton: UIButton!
    @IBOutlet weak var walkTransportButton: UIButton!
    @IBOutlet weak var foodItemsTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var daysHoursLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func transportButtonTapped(_ sender: UIButton) {
        if let lastTransportButton = lastTransportButtonTapped {
            lastTransportButton.backgroundColor = .white
        }
        lastTransportButtonTapped = sender
        sender.backgroundColor = .lightGray
        
        switch(sender.tag) {
            case TransportType.Walk.rawValue:
                print("Tapped walk");
                currentTransportType = .walking
                break
            case TransportType.Car.rawValue:
                print("Tapped car");
                currentTransportType = .automobile
                break
            default:
                break
        }
        
        guard let directions = getDirections() else { return }
        displayDirectionPath(directions: directions)
    }
    
    @IBAction func bookmarkButtonClicked(_ sender: UIButton) {
        if bookmarksManager.isBookmarked(id: foodTruck.id) {
            sender.setImage( UIImage(named:"bookmark"), for: .normal)
            bookmarksManager.removeBookmark(id: foodTruck.id)
        } else {
            sender.setImage(UIImage(named:"bookmarked"), for: .normal)
            bookmarksManager.bookmark(id: foodTruck.id)
        }
    }
    
    func styleTransportButtons(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        let foodTruckCoords = CLLocationCoordinate2D(latitude: foodTruck.latitude, longitude: foodTruck.longitude)
        
        if userAllowsLocation() {
            mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = CLLocationDistance(0.5)
            locationManager.startUpdatingLocation()
            
            styleTransportButtons(button: walkTransportButton)
            styleTransportButtons(button: carTransportButton)
        } else {
            walkTransportButton.removeFromSuperview()
            carTransportButton.removeFromSuperview()
            etaLabel.removeFromSuperview()
            directionsLabel.removeFromSuperview()
            distanceLabel.removeFromSuperview()
            
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: foodTruckCoords, span: span)
            mapView.setRegion(region, animated: false)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = foodTruckCoords
        mapView.addAnnotation(annotation)
        
        nameLabel.text = foodTruck.name
        daysHoursLabel.text = foodTruck.daysHours
        addressLabel.text = foodTruck.address.capitalized
        
        // update the image to match the current bookmark state
        if bookmarksManager.isBookmarked(id: foodTruck.id) {
            bookmarkButton.setImage(UIImage(named:"bookmarked"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named:"bookmark"), for: .normal)
        }
    }
    
    func userAllowsLocation() -> Bool {
        return CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    func getDirections() -> MKDirections? {
        if let userLocation = locationManager.location {
            let foodTruckCoords = CLLocationCoordinate2D(latitude: foodTruck.latitude, longitude: foodTruck.longitude)
            let userCoords = userLocation.coordinate
            let transportType = currentTransportType
            let directions = getDirections(source: userCoords, destination: foodTruckCoords, transportType: transportType)
            return directions
        } else {
            return nil
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
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
    
    func displayDirectionPath(directions: MKDirections) {
        directions.calculate(completionHandler: { response, error in
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                return
            }
            for overlay in self.mapView.overlays {
                self.mapView.remove(overlay)
            }
            
            let route = response.routes[0]
            let distance = route.distance.magnitude.rounded()
            let eta = route.expectedTravelTime
            let etaMins = (eta.magnitude / 60).rounded()
            let mapRect = route.polyline.boundingMapRect
            let coordinateRegion = MKCoordinateRegionForMapRect(mapRect)
            self.mapView.setRegion(coordinateRegion, animated: false)
            self.mapView.add(route.polyline, level: .aboveRoads)
            self.etaLabel.text = "(\(etaMins) min)"
            self.distanceLabel.text = "\(distance)m"
        })
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
        dismiss(animated: true, completion: nil)
    }
}

