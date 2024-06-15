//
//  LocationCategory.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/1/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import Foundation

class LocationCategory {
    
    var locationCategoryID: Int
    var locationCategoryName: String
    var displayOrder: Int
    
    init(locationCategoryID: Int, locationCategoryName: String, displayOrder: Int) {
        self.locationCategoryID = locationCategoryID
        self.locationCategoryName = locationCategoryName
        self.displayOrder = displayOrder
    }
    
}
