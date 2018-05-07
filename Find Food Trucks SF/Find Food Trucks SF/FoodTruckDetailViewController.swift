//
//  FoodTruckDetailViewController.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 4/24/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit
import MapKit

class FoodTruckDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
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

    
    @IBAction func bookmarkButtonClicked(_ sender: UIButton) {
        if isBookmarked() {
            sender.setImage( UIImage(named:"unbookmarked"), for: .normal)
            removeBookmark()
        } else {
            sender.setImage(UIImage(named:"bookmark"), for: .normal)
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = CLLocationDistance(0.5)
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: foodTruck.latitude, longitude: foodTruck.longitude)
        mapView.addAnnotation(annotation)
        
        nameLabel.text = foodTruck.name
        daysHoursLabel.text = foodTruck.daysHours
        addressLabel.text = foodTruck.address
        locationDescriptionLabel.text = foodTruck.locationDescription
        
        // update the image to match the current bookmark state
        if isBookmarked() {
            bookmarkButton.setImage(UIImage(named:"bookmark"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named:"unbookmarked"), for: .normal)
        }
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
