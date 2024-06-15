//
//  LocationHelper.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/2/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class LocationHelper {
    
    private var storyboard: UIStoryboard?
    private var presentController: UIViewController
    private var foodLocationTableView: UITableView?
    
    
    //    var foodLocationsArray = ["Kitchen Fridge", "Upstairs Fridge", "Garage Fridge"]
    //    var upcomingFoodsArray1 = ["Milk", "Eggs", "Grapes"]
    //    var upcomingFoodsDaysLeft = ["1 Day", "2 Days", "3 Days"]
        
    var searchController: UISearchController?
    var db: LocalDatabase?
    var locationList: [Location] = []
    var locationCategoryList: [LocationCategory] = []
    var searching: Bool = false
    var searchResultsList: [Location] = []
    
    var c = Constants()
    
//    private var upcomingFoodList: [String] = []
//    private var upcomingFoodDaysLeftList: [String] = []

    //    private var counter = 0
        
    init(storyboard: UIStoryboard?, presentController: UIViewController, searchController: UISearchController, foodLocationTableView: UITableView) {
        
        self.storyboard = storyboard
        self.presentController = presentController
        //self.foodLocationsArray = ["Kitchen Fridge", "Upstairs Fridge", "Garage Fridge"]
        self.db = LocalDatabase()
        //self.locationList = self.db!.readTableLocation()
        self.locationCategoryList = self.db!.readTableLocationCategory()
        self.foodLocationTableView = foodLocationTableView
        self.searchController = searchController
        
        self.db?.getRowCount(tableName: "food")
        
    }
        
    init(storyboard: UIStoryboard?, presentController: UIViewController, locationList: [Location], locationCategoryList: [LocationCategory], comingFromOtherVC: Bool) {
        
        self.locationList = locationList
        self.storyboard = storyboard
        self.presentController = presentController
        self.locationList = locationList
        self.locationCategoryList = locationCategoryList
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.searchController?.isActive)! {
            return self.searchResultsList.count
        } else {
            return self.locationList.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCellIdentifier", for: indexPath) as! LocationTableViewCell
        var upcomingFoodList: [Food] = []
        
        print(indexPath.row)
        
//        if (self.searchController?.isActive)! && indexPath.row < self.searchResultsList.count {
//            cell.locationTitleLabel.text = self.searchResultsList[indexPath.row].locationName
//            upcomingFoodList = self.db!.readTableFood(locationID: self.searchResultsList[indexPath.row].locationID)
//        } else if (self.searchController?.isActive)! {
//            cell.locationTitleLabel.text = ""
//
//        } else {
//            cell.locationTitleLabel.text = self.locationList[indexPath.row].locationName
//            upcomingFoodList = self.db!.readTableFood(locationID: self.locationList[indexPath.row].locationID)
//        }
  
        if (self.searchController?.isActive)!{
            
            cell.locationTitleLabel.text = self.searchResultsList[indexPath.row].locationName
            upcomingFoodList = self.db!.readTableFood(locationID: self.searchResultsList[indexPath.row].locationID)
            
            if self.searchResultsList[indexPath.row].locationCategoryID == 1 {
                cell.locationIconImageView.image = UIImage(named: self.c.iconFridgeDark)
            } else if self.searchResultsList[indexPath.row].locationCategoryID == 2 {
                cell.locationIconImageView.image = UIImage(named: self.c.iconFreezerDark)
            } else if self.searchResultsList[indexPath.row].locationCategoryID == 3 {
                cell.locationIconImageView.image = UIImage(named: self.c.iconPantryDark)
            } else if self.searchResultsList[indexPath.row].locationCategoryID == 4 {
                cell.locationIconImageView.image = UIImage(named: self.c.iconOtherDark)
            }
            
        } else {
            
            cell.locationTitleLabel.text = self.locationList[indexPath.row].locationName
            upcomingFoodList = self.db!.readTableFood(locationID: self.locationList[indexPath.row].locationID)
            
            if self.locationList[indexPath.row].locationCategoryID == 1 {
                cell.locationIconImageView.image = UIImage(named: self.c.iconFridgeDark)
            } else if self.locationList[indexPath.row].locationCategoryID == 2 {
                cell.locationIconImageView.image = UIImage(named: self.c.iconFreezerDark)
            } else if self.locationList[indexPath.row].locationCategoryID == 3 {
                cell.locationIconImageView.image = UIImage(named: self.c.iconPantryDark)
            } else if self.locationList[indexPath.row].locationCategoryID == 4 {
                cell.locationIconImageView.image = UIImage(named: self.c.iconOtherDark)
            }
            
        }
        
        if upcomingFoodList.count >= 3 {
                
            cell.firstFoodLabel.text = upcomingFoodList[0].foodName
            cell.secondFoodLabel.text = upcomingFoodList[1].foodName
            cell.thirdFoodLabel.text = upcomingFoodList[2].foodName
            
            if self.db!.daysTillExpiration(expirationDate: upcomingFoodList[0].expirationDate) <= 0 {
                cell.firstExpirationLabel.text = "Expired"
                cell.firstExpirationLabel.textColor = self.c.foodExpiredColor
            } else {
                cell.firstExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[0].expirationDate)) day(s) left"
                cell.firstExpirationLabel.textColor = .black
            }

            if self.db!.daysTillExpiration(expirationDate: upcomingFoodList[1].expirationDate) <= 0 {
                cell.secondExpirationLabel.text = "Expired"
                cell.secondExpirationLabel.textColor = self.c.foodExpiredColor
            } else {
                cell.secondExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[1].expirationDate)) day(s) left"
                cell.secondExpirationLabel.textColor = .black
            }
            
            if self.db!.daysTillExpiration(expirationDate: upcomingFoodList[2].expirationDate) <= 0 {
                cell.thirdExpirationLabel.text = "Expired"
                cell.thirdExpirationLabel.textColor = self.c.foodExpiredColor
            } else {
                cell.thirdExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[2].expirationDate)) day(s) left"
                cell.thirdExpirationLabel.textColor = .black
            }
            
//            cell.secondExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[1].expirationDate)) day(s) left"
//            cell.thirdExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[2].expirationDate)) day(s) left"
                
        } else if upcomingFoodList.count >= 2 {
                
            cell.firstFoodLabel.text = upcomingFoodList[0].foodName
            cell.secondFoodLabel.text = upcomingFoodList[1].foodName
            cell.thirdFoodLabel.text = ""
            
            
            if self.db!.daysTillExpiration(expirationDate: upcomingFoodList[0].expirationDate) <= 0 {
                cell.firstExpirationLabel.text = "Expired"
                cell.firstExpirationLabel.textColor = self.c.foodExpiredColor
            } else {
                cell.firstExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[0].expirationDate)) day(s) left"
                cell.firstExpirationLabel.textColor = .black
            }

            if self.db!.daysTillExpiration(expirationDate: upcomingFoodList[1].expirationDate) <= 0 {
                cell.secondExpirationLabel.text = "Expired"
                cell.secondExpirationLabel.textColor = self.c.foodExpiredColor
            } else {
                cell.secondExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[1].expirationDate)) day(s) left"
                cell.secondExpirationLabel.textColor = .black
            }
            
//            cell.firstExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[0].expirationDate)) day(s) left"
//            cell.secondExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[1].expirationDate)) day(s) left"
            
            cell.thirdExpirationLabel.text = ""
                
        } else if upcomingFoodList.count >= 1 {
                
            cell.firstFoodLabel.text = upcomingFoodList[0].foodName
            cell.secondFoodLabel.text = ""
            cell.thirdFoodLabel.text = ""
              
            if self.db!.daysTillExpiration(expirationDate: upcomingFoodList[0].expirationDate) <= 0 {
                cell.firstExpirationLabel.text = "Expired"
                cell.firstExpirationLabel.textColor = self.c.foodExpiredColor
            } else {
                cell.firstExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[0].expirationDate)) day(s) left"
                cell.firstExpirationLabel.textColor = .black
            }
            
            //cell.firstExpirationLabel.text = "\(self.db!.daysTillExpiration(expirationDate: upcomingFoodList[0].expirationDate)) day(s) left"
            cell.secondExpirationLabel.text = ""
            cell.thirdExpirationLabel.text = ""
            
        } else {
                
            cell.firstFoodLabel.text = "No Items"
            cell.secondFoodLabel.text = ""
            cell.thirdFoodLabel.text = ""
                
            cell.firstExpirationLabel.text = ""
            cell.secondExpirationLabel.text = ""
            cell.thirdExpirationLabel.text = ""
                
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if self.locationList.count > 1 {
                
                let alert = UIAlertController(title: "Are You Sure You Want to Delete?", message: "Deleting this location will remove the location and all food logged in it. Are you sure you want to delete this location?", preferredStyle: UIAlertController.Style.alert)

                let doNotDeleteAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                    
                }
                
                let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                    self.db?.deleteLocation(locationID: self.locationList[indexPath.row].locationID)
                    self.locationList.remove(at: indexPath.row)
                    self.foodLocationTableView?.deleteRows(at: [indexPath], with: .fade)
                    self.foodLocationTableView?.reloadData()
                }
                
                alert.addAction(doNotDeleteAction)
                alert.addAction(deleteAction)
                            
                DispatchQueue.main.async {
                    self.presentController.present(alert, animated: true)
                }
                
            } else {
                
                let alert = UIAlertController(title: "Location Cannot Be Delete", message: "There must be at least one location available at all times", preferredStyle: UIAlertController.Style.alert)
                let dismiss = UIAlertAction(title: "OK", style: .destructive) { (action) in
                    self.presentController.viewDidLoad()
                }
                
                alert.addAction(dismiss)
                
                DispatchQueue.main.async {
                    self.presentController.present(alert, animated: true)
                }
                
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "FoodViewController") as! FoodViewController
        
        if (self.searchController?.isActive)! {
            vc.locationID = self.searchResultsList[indexPath.row].locationID
            vc.title = self.searchResultsList[indexPath.row].locationName
        } else {
            vc.locationID = self.locationList[indexPath.row].locationID
            vc.title = self.locationList[indexPath.row].locationName
        }
        
        vc.db = self.db
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.presentController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addLocation() {

        let vc = self.storyboard?.instantiateViewController(identifier: "AddLocationViewController") as! AddLocationViewController
        vc.locationList = self.locationList
        vc.locationCategoryList = self.locationCategoryList
        vc.db = self.db
        self.presentController.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func refreshLocationList() {
        self.locationList = self.db!.readTableLocation()
    }
    
    
    func addItem() {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddFoodViewController") as! AddFoodViewController
        vc.db = self.db
        vc.locationList = self.locationList
        
        self.presentController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scanItem() {
        let vc = self.storyboard?.instantiateViewController(identifier: "CameraViewController") as! CameraViewController
        vc.db = self.db
        vc.locationList = self.locationList
        self.presentController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchForFoodInStorage(foodNameSearchString: String) {
        
        self.searching = true
        self.searchResultsList = self.db!.searchForFoodLocation(foodNameSearchString: foodNameSearchString)
        
        for item in searchResultsList {
            print(item.locationID)
            print(item.locationName)
        }
        
        self.foodLocationTableView?.reloadData()
        
    }
    
}
