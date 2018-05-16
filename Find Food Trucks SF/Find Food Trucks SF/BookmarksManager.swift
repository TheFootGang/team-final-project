//
//  BookmarksManager.swift
//  Find Food Trucks SF
//
//  Created by Stanley on 5/13/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import Foundation

class BookmarksManager {
    // Returns whether the bookmark is stored in UserDefaults
    func isBookmarked(id: Int) -> Bool {
        if(UserDefaults.standard.object(forKey: "\(id)") != nil) {
            return true
        }
        return false
    }
    
    // Store bookmark for this truck as a <Key, Value> pair into UserDefaults
    // @Key: id of the food truck
    // @Value: empty string
    func bookmark(id: Int) {
        UserDefaults.standard.set("", forKey: "\(id)")
    }
    
    // Remove this bookmark from UserDefaults
    func removeBookmark(id: Int) {
        UserDefaults.standard.removeObject(forKey: "\(id)")
    }
}
