//
//  StringPadding.swift
//  Find Food Trucks SF
//
//  Created by Brandonyu on 5/14/18.
//  Copyright © 2018 TheFootGang. All rights reserved.
//

import Foundation

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let newLength = self.characters.count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            return self.substring(from: index(self.startIndex, offsetBy: newLength - toLength))
        }
    }
}
