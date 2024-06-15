//
//  CameraModel.swift
//  ShelfLife
//
//  Created by Dev User1 on 6/30/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class CameraHelper {
    
    private var viewController: UIViewController
    private var storyboard: UIStoryboard?
    
    private var db: LocalDatabase
    private var locationList: [Location]

    private var locationID: Int?
    
    init(viewController: UIViewController, storyboard: UIStoryboard, db: LocalDatabase, locationList: [Location], locationID: Int?) {
        self.viewController = viewController
        self.storyboard = storyboard
        self.db = db
        self.locationList = locationList
        self.locationID = locationID
    }
    
    func scanSuccessful(foodName: String) {
        
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(identifier: "AddFoodViewController") as! AddFoodViewController
            vc.foodName = foodName
            
            vc.db = self.db
            vc.locationList = self.locationList
            vc.locationID = self.locationID
            vc.modalPresentationStyle = .overFullScreen
            self.viewController.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func addProductManually() {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddFoodViewController") as! AddFoodViewController
        vc.db = self.db
        vc.locationList = self.locationList
        vc.locationID = self.locationID
        vc.modalPresentationStyle = .overFullScreen
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
}
