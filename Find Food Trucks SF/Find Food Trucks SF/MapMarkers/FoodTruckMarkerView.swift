//
//  FoodTruckMarkerAnnotationView.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 5/9/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import MapKit

class FoodTruckMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard (newValue as? FoodTruckAnnotation) != nil else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -3, y: 3)
            clusteringIdentifier = "foodTruckCluster"
            markerTintColor = .red
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
    }
}
