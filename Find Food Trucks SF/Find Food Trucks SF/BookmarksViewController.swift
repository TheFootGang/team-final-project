//
//  BookmarkViewController.swift
//  Find Food Trucks SF
//
//  Created by Mark on 4/22/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindToBookmarksFromDetail(segue:UIStoryboardSegue) {}

    var bookmarks: [FoodTruck] = []
    let service: FoodTruckService = FoodTruckService()
    let userDefaults = UserDefaults.standard
    
    @IBAction func tapRefresh(_ sender: UIButton) {
        viewDidLoad()
        for bookmarked in self.bookmarks {
            print(bookmarked.name)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bookmarks.removeAll()
        service.getFoodTrucks() { [unowned self] (foodTrucks: [FoodTruck]?) in
            guard let trucks = foodTrucks else {
                print("Error fetching food trucks.")
                return
            }
            
            let keys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
            for key in keys {
                if let key = Int(key) {
                    if let truck = trucks.first(where: { $0.id == key}) {
                        self.bookmarks.append(truck)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell") as! BookmarkCell
        let bookmark = bookmarks[indexPath.row]
        cell.nameLabel.text = bookmark.name
        cell.addressLabel.text = bookmark.address.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "bookmarksToDetailSegueId", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookmarksToDetailSegueId" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                let vc = segue.destination as! FoodTruckDetailViewController
                vc.foodTruck = self.bookmarks[selectedRow]
                vc.unwindSegueId = "unwindToBookmarksSegueId"
            }
        }
    }
}

