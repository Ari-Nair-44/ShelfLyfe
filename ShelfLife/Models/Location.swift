//
//  Location.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/1/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import Foundation

class Location {
    
    var locationID: Int
    var locationCategoryID: Int
    var locationName: String
    var displayOrder: Int
    
    init(locationID: Int, locationCategoryID: Int, locationName: String, displayOrder: Int) {
        self.locationID = locationID
        self.locationCategoryID = locationCategoryID
        self.locationName = locationName
        self.displayOrder = displayOrder
    }
    
}
