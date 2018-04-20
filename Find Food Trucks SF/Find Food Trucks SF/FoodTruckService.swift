//
//  FoodTruckService.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 4/10/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import Foundation

import Alamofire

class FoodTruckService {
    
    func getFoodTrucks(completionHandler: @escaping ([FoodTruck]?) -> Void) {
        let url = "https://data.sfgov.org/resource/6a9r-agq8.json?facilitytype=Truck&status=APPROVED&$where=dayshours%20is%20not%20null&$select=objectid,applicant,address,dayshours,fooditems,latitude,longitude,locationdescription"
        
        Alamofire.request(url).responseJSON { (response) in
            guard
                let responseJson = response.result.value as? [[String: Any]]
                else {
                    completionHandler(nil)
                    return
            }
            
            var foodTrucks: [FoodTruck] = []
            
            for responseItem in responseJson {
                if let foodTruck = FoodTruck(json: responseItem) {
                    foodTrucks.append(foodTruck)
                } else {
                    print("Error")
                }
            }
            
            completionHandler(foodTrucks)
        }
    }
    
}
