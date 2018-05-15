//
//  NearbyViewController.swift
//  Find Food Trucks SF
//
//  Created by Brandon on 5/11/18.
//  Edited by Stanley on 5/14/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var foodTrucks: [FoodTruck] = []
    var nearbyList: [(FoodTruck, Double)] = []
    let locationManager = CLLocationManager()
    let service: FoodTruckService = FoodTruckService()
    let defaultLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistance(1)
        
        service.getFoodTrucks() { [unowned self] (foodTrucks: [FoodTruck]?) in
            guard let trucks = foodTrucks else {
                print("Error fetching food trucks.")
                return
            }
            
            self.foodTrucks = trucks
            self.filterTrucksOnUserLocation()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.nearbyList.removeAll()
        self.filterTrucksOnUserLocation()
        self.tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        filterTrucksOnUserLocation()
        tableView.reloadData()
    }
    
    func userAllowsLocation() -> Bool {
        return CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    func filterTrucksOnUserLocation() {
        let mile = 1609.34
        if userAllowsLocation(), let userLocation = locationManager.location {
            filterTrucks(location: userLocation, distance: mile)
        } else {
            filterTrucks(location: defaultLocation, distance: mile)
        }
        
    }
    
    func filterTrucks(location: CLLocation, distance: Double) {
        for truck in foodTrucks {
            let truckLocation = CLLocation(latitude: truck.latitude, longitude: truck.longitude)
            let distanceInMeters = location.distance(from: truckLocation).magnitude
            
            if distanceInMeters <= distance {
                nearbyList.append((truck, distanceInMeters))
            }
            
            let nearbySortedList = nearbyList.sorted(by: { $0.1 < $1.1 })
            nearbyList = nearbySortedList
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyCell") as! NearbyCell
        let truck = nearbyList[indexPath.row]
        cell.nameLabel.text = truck.0.name
        cell.distanceLabel.text = "\(truck.1.magnitude.rounded())m"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "nearbyToDetailSegueId", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nearbyToDetailSegueId" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let vc = segue.destination as! FoodTruckDetailViewController
                vc.foodTruck = nearbyList[selectedRow].0
            }
        }
    }
    
}
