//
//  AddFoodHelper.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/7/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit
import UserNotifications

class AddFoodHelper {
    
    private var viewController: UIViewController
    private var storyboard: UIStoryboard?
    private var foodTextField: UITextField
    private var tagsTextField: UITextField
    private var expirationLabel: UILabel
    private var expirationDatePicker: UIDatePicker
    
    private var db: LocalDatabase
    private var locationList: [Location]
    private var locationID: Int?
    
//    private var fridgeIconString = "icon-fridge-light"
//    private var freezerIconString = "icon-freezer-light"
//    private var pantryIconString = "icon-pantry-light"
//    private var otherIconString = "icon-other-light"

    private var date = ""
    
    var quantity = 1
    
    var c = Constants()
    
    //var date = Date()
    
    init(viewController: UIViewController, storyboard: UIStoryboard, foodTextField: UITextField, tagsTextField: UITextField, expirationLabel: UILabel, expirationDatePicker: UIDatePicker, db: LocalDatabase, locationList: [Location], locationID: Int?) {
        
        self.viewController = viewController
        self.storyboard = storyboard
        self.foodTextField = foodTextField
        self.tagsTextField = tagsTextField
        self.expirationLabel = expirationLabel
        self.expirationDatePicker = expirationDatePicker
        self.db = db
        self.locationList = locationList
        self.locationID = locationID
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MM/dd/yyyy"
        
        self.expirationLabel.text = "Expiration Date: \(displayDateFormatter.string(from: Date()))"
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFoodCellIdentifier", for: indexPath) as! AddFoodTableViewCell
        cell.locationLabel.text = self.locationList[indexPath.row].locationName
        
        if self.locationList[indexPath.row].locationID != locationID {
            
            if self.locationList[indexPath.row].locationCategoryID == 1 {
                
                cell.iconImageView.image = UIImage(named: self.c.iconFridgeLight)
                
            } else if self.locationList[indexPath.row].locationCategoryID == 2 {
                
                cell.iconImageView.image = UIImage(named: self.c.iconFreezerLight)
                
            } else if self.locationList[indexPath.row].locationCategoryID == 3 {
                
                cell.iconImageView.image = UIImage(named: self.c.iconPantryLight)
                
            } else if self.locationList[indexPath.row].locationCategoryID == 4 {
                cell.iconImageView.image = UIImage(named: self.c.iconOtherLight)
            }
            
        } else {
            
            if self.locationList[indexPath.row].locationCategoryID == 1 {
                
                cell.iconImageView.image = UIImage(named: self.c.iconFridgeDark)
                
            } else if self.locationList[indexPath.row].locationCategoryID == 2 {
                
                cell.iconImageView.image = UIImage(named: self.c.iconFreezerDark)
                
            } else if self.locationList[indexPath.row].locationCategoryID == 3 {
                
                cell.iconImageView.image = UIImage(named: self.c.iconPantryDark)
                
            } else if self.locationList[indexPath.row].locationCategoryID == 4 {
                cell.iconImageView.image = UIImage(named: self.c.iconOtherDark)
            }
            
        }

        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("select")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFoodCellIdentifier", for: indexPath) as! AddFoodTableViewCell
//        cell.locationLabel.text = self.locationList[indexPath.row].locationName
        
//        self.locationID = self.locationList[indexPath.row].locationID
//
//
//        if self.locationList[indexPath.row].locationCategoryID == 1 {
//
//            self.fridgeClicked()
//
//        } else if self.locationList[indexPath.row].locationCategoryID == 2 {
//
//            self.freezerClicked()
//
//        } else if self.locationList[indexPath.row].locationCategoryID == 3 {
//
//            self.pantryClicked()
//
//        } else if self.locationList[indexPath.row].locationCategoryID == 4 {
//
//            self.otherClicked()
//
//        }
        
        self.locationID = self.locationList[indexPath.row].locationID
        tableView.reloadData()
        
    }
    
//    func fridgeClicked() {
//        self.fridgeIconString = "icon-fridge-dark"
//        self.freezerIconString = "icon-freezer-light"
//        self.pantryIconString = "icon-pantry-light"
//        self.otherIconString = "icon-other-light"
//    }
//
//    func freezerClicked() {
//        self.fridgeIconString = "icon-fridge-light"
//        self.freezerIconString = "icon-freezer-dark"
//        self.pantryIconString = "icon-pantry-light"
//        self.otherIconString = "icon-other-light"
//    }
//
//    func pantryClicked() {
//        self.fridgeIconString = "icon-fridge-light"
//        self.freezerIconString = "icon-freezer-light"
//        self.pantryIconString = "icon-pantry-dark"
//        self.otherIconString = "icon-other-light"
//    }
//
//    func otherClicked() {
//        self.fridgeIconString = "icon-fridge-light"
//        self.freezerIconString = "icon-freezer-light"
//        self.pantryIconString = "icon-pantry-light"
//        self.otherIconString = "icon-other-dark"
//    }
    
    func expirationDatePickerChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.date = dateFormatter.string(from: self.expirationDatePicker.date)
        print(date)
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MM/dd/yyyy"
    
        let displayDate = displayDateFormatter.string(from: self.expirationDatePicker.date)
        
        self.expirationLabel.text = "Expiration Date: \(displayDate)"
        
    }
    
    func addItem() {
        
        if self.foodTextField.text != "" {
                
            if locationID != nil {
                
                if self.date == "" {
                
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    self.date = dateFormatter.string(from: self.expirationDatePicker.date)
                    
                }
                
                self.db.insertRowFood(locationID: self.locationID!, foodName: self.foodTextField.text!, expirationDate: self.date, tags: self.tagsTextField.text!, quantity: self.quantity)
                
                let center = UNUserNotificationCenter.current()
                
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                
                }
                
                let content = UNMutableNotificationContent()
                content.title = "Item Expired"
                content.body = "Your \(self.foodTextField.text!) Expired!"
                
//                let date = Date().addingTimeInterval(30)
//                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                
                let notificationDate = self.expirationDatePicker.date
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: notificationDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                
                //let uuidString = UUID().uuidString
                let identifier = self.db.readTableFood().last!.foodID
                print(identifier)
                let request = UNNotificationRequest(identifier: "\(String(describing: identifier))", content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    
                }
                
                self.viewController.navigationController?.popViewController(animated: true)
                self.viewController.dismiss(animated: true, completion: nil)
                
            } else {
                    
                let alert = UIAlertController(title: "Choose a Location", message: "Pick a location to store this item", preferredStyle: UIAlertController.Style.alert)

                let dismiss = UIAlertAction(title: "OK", style: .destructive) { (action) in
                        self.viewController.viewDidLoad()
                }
                    
                alert.addAction(dismiss)
                DispatchQueue.main.async {
                    self.viewController.present(alert, animated: true)
                }
            
            }
            
        } else {
            
            let alert = UIAlertController(title: "Invalid Item Name", message: "Reenter a valid item name", preferredStyle: UIAlertController.Style.alert)

            let dismiss = UIAlertAction(title: "OK", style: .destructive) { (action) in
                self.viewController.viewDidLoad()
            }
            
            alert.addAction(dismiss)
            DispatchQueue.main.async {
                self.viewController.present(alert, animated: true)
            }
            
        }
        
    }
    
}

