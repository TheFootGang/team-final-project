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

class NearbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var myTableView: UITableView!
    
    var foodTrucks: [FoodTruck] = []
    var nearbyList: [FoodTruck] = []
    let locationManager = CLLocationManager()
    let service: FoodTruckService = FoodTruckService()
    let defaultCoords = CLLocation(latitude: 37.7749, longitude: -122.4194)

    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getFoodTrucks() { [unowned self] (foodTrucks: [FoodTruck]?) in
            guard let trucks = foodTrucks else {
                print("Error fetching food trucks.")
                return
            }
            
            self.foodTrucks = trucks
            
            if self.userAllowsLocation() {
                if let userLocation = self.locationManager.location {
                    let mile = 1609.34
                    self.filterTrucks(location: userLocation, distance: mile)
                }
            } else {
                // change the ui to display to a label
                // asking the user for location permissions
                // and a button that leads to app settings location services
            }
            
            self.myTableView.reloadData()
        }
    }
    
    func userAllowsLocation() -> Bool {
        return CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    // loops over all the foodtrucks and filter according to coordinates and distance
    func filterTrucks(location: CLLocation, distance: Double) {
        for truck in self.foodTrucks {
            let truckLocation = CLLocation(latitude: truck.latitude, longitude: truck.longitude)
            let distanceInMeters = location.distance(from: truckLocation).magnitude
            
            if distanceInMeters <= distance {
                self.nearbyList.append(truck)
            
                // TODO: sort the list by distance
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = nearbyList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "nearbyToDetailSegueId", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nearbyToDetailSegueId" {
            if let indexPath = myTableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let vc = segue.destination as! FoodTruckDetailViewController
                vc.foodTruck = self.nearbyList[selectedRow]
            }
        }
    }
}
