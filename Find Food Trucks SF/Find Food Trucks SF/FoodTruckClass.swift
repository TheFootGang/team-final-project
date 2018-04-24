//
//  FoodTruckClass.swift
//  Find Food Trucks SF
//
//  Created by Brandonyu on 4/23/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import Foundation
import MapKit

class FoodTruckClass: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let category: String
    let operatingTime: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, category: String, operatingTime: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.category = category
        self.operatingTime = operatingTime
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
