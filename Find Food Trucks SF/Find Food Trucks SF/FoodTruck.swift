//
//  FoodTruck.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 4/13/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import Foundation

struct FoodTruck {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let daysHours: String
    let foodItems: [String]

    init?(json: [String: Any]) {
        guard
            let id = json["objectid"] as? String,
            let name = json["applicant"] as? String,
            let address = json["address"] as? String,
            let latitude = json["latitude"] as? String,
            let longitude = json["longitude"] as? String,
            let daysHours = json["dayshours"] as? String
        else {
            return nil
        }
        
        self.id = Int(id)!
        self.name = name
        self.address = address
        self.latitude = Double(latitude)!
        self.longitude = Double(longitude)!
        self.daysHours = daysHours
        
        if let foodItems = json["fooditems"] as? String {
            self.foodItems = foodItems.components(separatedBy: ": ")
        } else {
            self.foodItems = []
        }
    }
    
}
