//
//  Food.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/1/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import Foundation

class Food {
    
    var foodID: Int
    var storageID: Int
    var foodName: String
    var expirationDate: String
    var tags: String
    var quantity: Int
    
    init(foodID: Int, storageID: Int, foodName: String, expirationDate: String, tags: String, quantity: Int) {
        self.foodID = foodID
        self.storageID = storageID
        self.foodName = foodName
        self.expirationDate = expirationDate
        self.tags = tags
        self.quantity = quantity
    }
    
}
