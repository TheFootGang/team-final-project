//
//  ViewController.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 4/9/18.
//  Edited by Brandon on 4/21/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//
/*
 * Copyright 2016 Google Inc. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
import UIKit
import GoogleMaps

class ViewController: UIViewController {

    let service: FoodTruckService = FoodTruckService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        marker.title = "Test"
        marker.snippet = "Test123"
        marker.map = mapView
        
        service.getFoodTrucks() { [unowned self] (foodTrucks: [FoodTruck]?) in
            guard let foodTrucks = foodTrucks else {
                print("Error fetching food trucks.")
                return
            }
            
            // do stuff with foodTrucks
            print(foodTrucks)
        }

        
        //Parsed JSON data stored into an array or struct, extract key data
        /*
         let trucks = [
         Foodtruck(name: "Truck 1", long:150.2999 , lat:  2.549),
         Foodtruck(name: "Truck 2", long:111.7779 , lat:  3.768),
         ]
         */
        
        //Loop to display all the Food Truck Markers
        /*
         for truck in trucks {
         let marker = GMSMarker()
         marker.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.long)
         marker.title = state.name
         marker.snippet = "Truck Info here"
         state_marker.map = mapView
         }
         
         */
    }
    /*
    override func loadView() {
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        marker.title = "Test"
        marker.snippet = "Test123"
        marker.map = mapView
        
        //Parsed JSON data stored into an array or struct, extract key data
        /*
         let trucks = [
         Foodtruck(name: "Truck 1", long:150.2999 , lat:  2.549),
         Foodtruck(name: "Truck 2", long:111.7779 , lat:  3.768),
         ]
         */
        
        //Loop to display all the Food Truck Markers
        /*
         for truck in trucks {
         let marker = GMSMarker()
         marker.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.long)
         marker.title = state.name
         marker.snippet = "Truck Info here"
         state_marker.map = mapView
         }
         
         */
    }
 */

}
