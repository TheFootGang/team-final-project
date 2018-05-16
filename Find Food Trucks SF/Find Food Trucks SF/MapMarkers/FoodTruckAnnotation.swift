//
//  FoodTruckAnnotation.swift
//  Find Food Trucks SF
//
//  Created by Brandon on 4/23/18
//  Edited by Stanley on 4/24/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//


import MapKit

class FoodTruckAnnotation: NSObject, MKAnnotation {
    let id: Int?
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    
    init(id: Int, title: String, subtitle: String, _ coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
}
