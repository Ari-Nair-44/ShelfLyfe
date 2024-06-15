//
//  FoodData.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/6/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import Foundation

struct FoodData: Codable {
//    let hints: [Hints]
    let product: Product
}

struct Product: Codable {
    let product_name: String
}
