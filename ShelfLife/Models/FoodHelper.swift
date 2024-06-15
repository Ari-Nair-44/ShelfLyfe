//
//  FoodHelper.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/3/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class FoodHelper {
    
    private var storyboard: UIStoryboard?
    private var presentController: UIViewController
//    private var searchController
    private var foodTableView: UITableView
    var db: LocalDatabase?
    var foodList: [Food] = []
    var locationID: Int
    var searchController: UISearchController?
    
    var searchResultsList: [Food] = []
    
    var c = Constants()
    
    init(storyboard: UIStoryboard?, presentController: UIViewController, searchController: UISearchController, foodTableView: UITableView, locationID: Int, db: LocalDatabase) {
        self.storyboard = storyboard
        self.presentController = presentController
        self.searchController = searchController
        self.foodTableView = foodTableView
        self.locationID = locationID
        self.db = db
        //self.foodList = self.db!.readTableFood(locationID: locationID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.searchController?.isActive)! {
            return self.searchResultsList.count
        } else {
            return self.foodList.count
        }
        
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCellIdentifier", for: indexPath) as! FoodTableViewCell
       
        if (self.searchController?.isActive)! {
            
            cell.foodNameLabel.text = "\(self.searchResultsList[indexPath.row].foodName) (\(self.searchResultsList[indexPath.row].quantity))"
            
            let displayDate = self.sqlDateToDisplayDate(sqlDate: self.searchResultsList[indexPath.row].expirationDate)
            
            if self.db!.daysTillExpiration(expirationDate: self.searchResultsList[indexPath.row].expirationDate) <= 0 {
                cell.expirationLabel.text = "Expired \(displayDate)"
                cell.expirationLabel.textColor = self.c.foodExpiredColor
                cell.foodIconImageView.image = UIImage(named: self.c.iconFoodExpired)
            } else {
                cell.expirationLabel.text = "Expires \(displayDate)"
                cell.expirationLabel.textColor = .black
                cell.foodIconImageView.image = UIImage(named: self.c.iconFoodGood)
            }
            
        } else {
            
            cell.foodNameLabel.text = "\(self.foodList[indexPath.row].foodName)  (\(self.foodList[indexPath.row].quantity))"
            
            let displayDate = self.sqlDateToDisplayDate(sqlDate: self.foodList[indexPath.row].expirationDate)
            
            print(self.db!.daysTillExpiration(expirationDate: foodList[indexPath.row].expirationDate))
            
            if self.db!.daysTillExpiration(expirationDate: self.foodList[indexPath.row].expirationDate) <= 0 {
                cell.expirationLabel.text = "Expired \(displayDate)"
                cell.expirationLabel.textColor = self.c.foodExpiredColor
                cell.foodIconImageView.image = UIImage(named: self.c.iconFoodExpired)
            } else {
                cell.expirationLabel.text = "Expires \(displayDate)"
                cell.expirationLabel.textColor = .black
                cell.foodIconImageView.image = UIImage(named: self.c.iconFoodGood)
            }
            
        }
        

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            let alert = UIAlertController(title: "Are You Sure You Want to Delete?", message: "Deleting this food will delete it permanently. Are you sure you want to remove this food?", preferredStyle: UIAlertController.Style.alert)
//
//            let doNotDeleteAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
//
//            }
//
//            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
//                self.db?.deleteRowFood(foodID: self.foodList[indexPath.row].foodID)
//                self.foodList.remove(at: indexPath.row)
//                self.foodTableView.deleteRows(at: [indexPath], with: .fade)
//                self.foodTableView.reloadData()
//            }
//
//            alert.addAction(doNotDeleteAction)
//            alert.addAction(deleteAction)
//
//            DispatchQueue.main.async {
//                self.presentController.present(alert, animated: true)
//            }
//
//        }
//
//    }
    
    func sqlDateToDisplayDate(sqlDate: String) -> String{
        
        let sqlFormatter = DateFormatter()
        sqlFormatter.dateFormat = "yyyy-MM-dd"
        let date = sqlFormatter.date(from: sqlDate)
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MM/dd/yyyy"
        
        let displayDate = displayFormatter.string(from: date!)
        
        return displayDate
        
    }
    
    func delete(indexPath: IndexPath) {
        
        print("Delete")
        let alert = UIAlertController(title: "Are You Sure You Want to Delete?", message: "Deleting this item will delete it permanently. Are you sure you want to remove this item?", preferredStyle: UIAlertController.Style.alert)

        let doNotDeleteAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            if (self.searchController?.isActive)! {
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(self.searchResultsList[indexPath.row].foodID)"])
                self.db?.deleteRowFood(foodID: self.searchResultsList[indexPath.row].foodID)
                self.searchResultsList.remove(at: indexPath.row)
                self.foodTableView.deleteRows(at: [indexPath], with: .fade)
                self.foodTableView.reloadData()
                
                
            } else {
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(self.foodList[indexPath.row].foodID)"])
                self.db?.deleteRowFood(foodID: self.foodList[indexPath.row].foodID)
                self.foodList.remove(at: indexPath.row)
                self.foodTableView.deleteRows(at: [indexPath], with: .fade)
                self.foodTableView.reloadData()
                
            }
        }
        
        alert.addAction(doNotDeleteAction)
        alert.addAction(deleteAction)
                    
        DispatchQueue.main.async {
            self.presentController.present(alert, animated: true)
        }
        
    }
    
    func edit(indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "UpdateFoodViewController") as! UpdateFoodViewController
        vc.db = self.db
        
        if (self.searchController?.isActive)! {
            
            vc.foodID = self.searchResultsList[indexPath.row].foodID
            vc.locationID = self.locationID
            vc.foodName = self.searchResultsList[indexPath.row].foodName
            vc.expirationDate = self.searchResultsList[indexPath.row].expirationDate
            vc.tags = self.searchResultsList[indexPath.row].tags
            vc.quantity = self.searchResultsList[indexPath.row].quantity
            
        } else {
            
            vc.foodID = self.foodList[indexPath.row].foodID
            vc.locationID = self.locationID
            vc.foodName = self.foodList[indexPath.row].foodName
            vc.expirationDate = self.foodList[indexPath.row].expirationDate
            vc.tags = self.foodList[indexPath.row].tags
            vc.quantity = self.foodList[indexPath.row].quantity
            
        }
        
        
        self.presentController.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func refreshFoodList() {
        self.foodList = self.db!.readTableFood(locationID: self.locationID)
    }
    
    func addItem() {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "AddFoodViewController") as! AddFoodViewController
        vc.db = self.db
        vc.locationID = self.locationID
        
        self.presentController.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scanItem() {
        let vc = self.storyboard?.instantiateViewController(identifier: "CameraViewController") as! CameraViewController
        vc.db = self.db
        vc.locationID = self.locationID
        vc.locationList = self.db?.readTableLocation()
        self.presentController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchForFood(foodNameSearchString: String) {
        
        self.searchResultsList = self.db!.searchForFood(foodNameSearchString: foodNameSearchString, locationID: self.locationID)
        
        for item in searchResultsList {
            print(item.foodID)
            print(item.foodName)
        }
        
        self.foodTableView.reloadData()
        
    }
    
//    func addFood() {
//        let vc = self.storyboard?.instantiateViewController(identifier: "CameraPreviewViewController") as! CameraPreviewViewController
//        vc.db = self.db
//        vc.foodLocationsArray = self.db?.readStorageLocationTable()
//        vc.storageID = self.storageID
//        self.presentController.navigationController?.pushViewController(vc, animated: true)
//    }
    
}
