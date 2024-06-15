//
//  FoodManagerDelegate.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/6/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import Foundation

protocol FoodManagerDelegate {
    func didUpdateFood(food: String)
    func didFailWithError(error: Error)
}
