//
//  NearbyViewController.swift
//  Find Food Trucks SF
//
//  Created by Brandon on 5/11/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var myTableView: UITableView!
    
    var foodTrucks: [FoodTruck] = []
    let service: FoodTruckService = FoodTruckService()
    //let nearbyList = ["a", "b", "c"]
    var nearbyList: [String] = []
    let coordinate0 = CLLocation(latitude: 37.7749, longitude: -122.4194)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return nearbyList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = nearbyList[indexPath.row]
        return cell
    }
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
     
     }
     */
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

            for foodTruck in trucks{
            let coordinate1 = CLLocation(latitude: foodTruck.latitude, longitude: foodTruck.longitude)
                let distanceInMeters = self.coordinate0.distance(from: coordinate1)
            if distanceInMeters <= 1609 && !self.nearbyList.contains(foodTruck.name){//find nearby foodtrucks within 1 mile radius, no duplicates.
                self.nearbyList.append(foodTruck.name)
            }
        }
            self.myTableView.reloadData()
            print(self.nearbyList.count)
        // Do any additional setup after loading the view, typically from a nib.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
