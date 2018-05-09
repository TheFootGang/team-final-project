//
//  FoodTruckClusterAnnotationView.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 5/9/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import MapKit

class FoodTruckClusterView: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        markerTintColor = .purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
