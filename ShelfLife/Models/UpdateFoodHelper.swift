//
//  UpdateFoodHelper.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/8/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class UpdateFoodHelper {
    
    private var viewController: UIViewController
    private var storyboard: UIStoryboard?
    private var foodNameTextField: UITextField
    private var tagsTextField: UITextField
    private var quantityLabel: UILabel
    private var expirationLabel: UILabel
    private var expirationDatePicker: UIDatePicker
    
    private var db: LocalDatabase
    private var foodID: Int
    private var locationList: [Location]
    private var locationID: Int
    private var foodName: String
    private var expirationDate: String
    private var tags: String

    var quantity: Int
    var c = Constants()
    var date = Date()
    
    init(viewController: UIViewController, storyboard: UIStoryboard, foodNameTextField: UITextField, tagsTextField: UITextField, quantityLabel: UILabel, expirationLabel: UILabel, expirationDatePicker: UIDatePicker, db: LocalDatabase, foodID: Int, locationList: [Location], locationID: Int, foodName: String, expirationDate: String, tags: String, quantity: Int) {
        
        self.viewController = viewController
        self.storyboard = storyboard
        self.foodNameTextField = foodNameTextField
        self.tagsTextField = tagsTextField
        self.quantityLabel = quantityLabel
        self.expirationLabel = expirationLabel
        self.expirationDatePicker = expirationDatePicker
        self.db = db
        self.foodID = foodID
        self.locationList = locationList
        self.locationID = locationID
        self.foodName = foodName
        self.expirationDate = expirationDate
        self.tags = tags
        self.quantity = quantity
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MM/dd/yyyy"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        self.foodNameTextField.text = self.foodName
        self.tagsTextField.text = self.tags
        self.quantityLabel.text = "\(quantity)"
        self.expirationLabel.text = "Expiration Date: \(displayDateFormatter.string(from: dateFormatter.date(from: self.expirationDate)!))"
        self.expirationDatePicker.date = dateFormatter.date(from: self.expirationDate)!
        
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
            
        self.locationID = self.locationList[indexPath.row].locationID
        tableView.reloadData()
        
    }
        
    func expirationDatePickerChanged() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
            
        self.expirationDate = dateFormatter.string(from: self.expirationDatePicker.date)
        print(expirationDate)
            
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MM/dd/yyyy"
        
        let displayDate = displayDateFormatter.string(from: self.expirationDatePicker.date)
            
        self.expirationLabel.text = "Expiration Date: \(displayDate)"
            
    }
    
    func quantityStepperChanged(sender: UIStepper) {
        self.quantity = Int(sender.value)
        self.quantityLabel.text = "\(quantity)"
    }
    
    func updateItem() {
        
        if self.foodNameTextField.text != "" {
                
            self.db.updateFood(foodID: self.foodID, locationID: self.locationID, foodName: self.foodNameTextField.text!, expirationDate: self.expirationDate, tags: self.tagsTextField.text!, quantity: self.quantity)
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(self.foodID)"])
            print("\(self.foodID) removed")
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Item Expired"
            content.body = "Your Updated \(self.foodName) Expired!"
  
//            let date = Date().addingTimeInterval(10)
//            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let notificationDate = self.expirationDatePicker.date
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            
            //let uuidString = UUID().uuidString
            let identifier = self.foodID
            let request = UNNotificationRequest(identifier: "\(String(describing: identifier))", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                
            }
            
            self.viewController.navigationController?.popViewController(animated: true)
            self.viewController.dismiss(animated: true, completion: nil)
                    
//            let alert = UIAlertController(title: "Choose a Location", message: "Pick a location to store this item", preferredStyle: UIAlertController.Style.alert)
//
//            let dismiss = UIAlertAction(title: "OK", style: .destructive) { (action) in
//                        self.viewController.viewDidLoad()
//            }
//
//            alert.addAction(dismiss)
//            DispatchQueue.main.async {
//                self.viewController.present(alert, animated: true)
//            }
            
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
