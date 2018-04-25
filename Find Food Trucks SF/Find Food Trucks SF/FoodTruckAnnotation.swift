//
//  FoodTruckAnnotation.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 4/24/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import MapKit

class FoodTruckAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, _ coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}
