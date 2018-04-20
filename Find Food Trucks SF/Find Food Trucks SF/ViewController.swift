//
//  ViewController.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 4/9/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let service: FoodTruckService = FoodTruckService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getFoodTrucks() { [unowned self] (foodTrucks: [FoodTruck]?) in
            guard let foodTrucks = foodTrucks else {
                print("Error fetching food trucks.")
                return
            }
            
            // do stuff with foodTrucks
            print(foodTrucks)
        }
    }

}
