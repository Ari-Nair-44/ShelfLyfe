//
//  AddLocationHelper.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/5/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class AddLocationHelper {
    
    private var viewController: UIViewController
    private var storyboard: UIStoryboard?
    private var locationNameTextField: UITextField
    private var fridgeIconImageView: UIImageView
    private var freezerIconImageView: UIImageView
    private var pantryIconImageView: UIImageView
    private var otherIconImageView: UIImageView
    private var locationList: [Location]
    private var locationCategoryList: [LocationCategory]
    
    private var db: LocalDatabase
    
    var locationCategoryID: Int = 1
    var displayOrder: Int = 1
    var locationName: String?
    
    var c = Constants()
    
    init(viewController: UIViewController, storyboard: UIStoryboard, locationNameTextField: UITextField, fridgeIconImageView: UIImageView, freezerIconImageView: UIImageView, pantryIconImageView: UIImageView, otherIconImageView: UIImageView, locationList: [Location], locationCategoryList: [LocationCategory], db: LocalDatabase) {
        
        self.viewController = viewController
        self.storyboard = storyboard
        self.locationNameTextField = locationNameTextField
        self.fridgeIconImageView = fridgeIconImageView
        self.freezerIconImageView = freezerIconImageView
        self.pantryIconImageView = pantryIconImageView
        self.otherIconImageView = otherIconImageView
        self.locationList = locationList
        self.locationCategoryList = locationCategoryList
        self.db = db
        
    }
    
    func addLocation() {
        
        print("Add")
        
        if self.locationNameTextField.text != "" {
            
            self.locationName = self.locationNameTextField.text
            print(self.locationName)
            
            self.db.insertRowLocation(locationCategoryID: self.locationCategoryID, locationName: self.locationName!, displayOrder: self.displayOrder)

//            let vc = self.storyboard?.instantiateViewController(identifier: "LocationViewController") as! LocationViewController
//            vc.db = self.db
//            let locationHelper = LocationHelper(storyboard: vc.storyboard, presentController: vc, locationList: self.locationList, locationCategoryList: self.locationCategoryList, comingFromOtherVC: true)
//            vc.locationHelper = locationHelper
//            vc.locationHelper?.locationList = self.locationList
//
//            vc.navigationController?.navigationBar.isHidden = true
//            let navController = UINavigationController(rootViewController: vc)
//            navController.modalPresentationStyle = .overFullScreen
//            self.viewController.present(navController, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Invalid Location Name", message: "Reenter a valid location name", preferredStyle: UIAlertController.Style.alert)

            let dismiss = UIAlertAction(title: "OK", style: .destructive) { (action) in
                self.viewController.viewDidLoad()
            }
            
            alert.addAction(dismiss)
            DispatchQueue.main.async {
                self.viewController.present(alert, animated: true)
            }
            
        }
            
        //self.db.insertRowLocation(locationCategoryID: <#T##Int#>, locationName: , displayOrder: <#T##Int#>)
        

        
    }
    
    func fridgeClicked() {
        
        self.locationCategoryID = 1
        self.displayOrder = 1
        self.fridgeIconImageView.image = UIImage(named: self.c.iconFridgeDark)
        self.freezerIconImageView.image = UIImage(named: self.c.iconFreezerLight)
        self.pantryIconImageView.image = UIImage(named: self.c.iconPantryLight)
        self.otherIconImageView.image = UIImage(named: self.c.iconOtherLight)
        
    }
    
    func freezerClicked() {
        
        self.locationCategoryID = 2
        self.displayOrder = 2
        self.fridgeIconImageView.image = UIImage(named: self.c.iconFridgeLight)
        self.freezerIconImageView.image = UIImage(named: self.c.iconFreezerDark)
        self.pantryIconImageView.image = UIImage(named: self.c.iconPantryLight)
        self.otherIconImageView.image = UIImage(named: self.c.iconOtherLight)

    }
    
    func pantryClicked() {
        
        self.locationCategoryID = 3
        self.displayOrder = 3
        self.fridgeIconImageView.image = UIImage(named: self.c.iconFridgeLight)
        self.freezerIconImageView.image = UIImage(named: self.c.iconFreezerLight)
        self.pantryIconImageView.image = UIImage(named: self.c.iconPantryDark)
        self.otherIconImageView.image = UIImage(named: self.c.iconOtherLight)

    }

    func otherClicked() {
        
        self.locationCategoryID = 4
        self.displayOrder = 4
        self.fridgeIconImageView.image = UIImage(named: self.c.iconFridgeLight)
        self.freezerIconImageView.image = UIImage(named: self.c.iconFreezerLight)
        self.pantryIconImageView.image = UIImage(named: self.c.iconPantryLight)
        self.otherIconImageView.image = UIImage(named: self.c.iconOtherDark)

    }

        
}
    

