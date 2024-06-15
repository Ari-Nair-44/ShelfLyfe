//
//  UpdateFoodViewController.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/8/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class UpdateFoodViewController: UIViewController {

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBOutlet weak var updateItemButton: UIButton! {
        didSet {
            self.updateItemButton.layer.cornerRadius = 3
        }
    }
    
    var locationList: [Location] = []
    var db: LocalDatabase?
    var updateFoodHelper: UpdateFoodHelper?
    var foodID: Int?
    var locationID: Int?
    var foodName: String?
    var expirationDate: String?
    var tags: String?
    var quantity: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationList = db!.readTableLocation()
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.foodNameTextField.clearButtonMode = .whileEditing
        self.tagsTextField.clearButtonMode = .whileEditing
        
        self.updateFoodHelper = UpdateFoodHelper(viewController: self, storyboard: self.storyboard!, foodNameTextField: self.foodNameTextField, tagsTextField: self.tagsTextField, quantityLabel: self.quantityLabel, expirationLabel: self.expirationLabel, expirationDatePicker: self.expirationDatePicker, db: self.db!, foodID: self.foodID!, locationList: self.locationList, locationID: self.locationID!, foodName: self.foodName!, expirationDate: self.expirationDate!, tags: self.tags!, quantity: self.quantity!)
        
        self.quantityStepper.value = Double(self.updateFoodHelper!.quantity)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func quantityStepperChanged(_ sender: UIStepper) {
        self.updateFoodHelper?.quantityStepperChanged(sender: sender)
    }
    
    @IBAction func expirationDatePickerChanged(_ sender: UIDatePicker) {
        self.updateFoodHelper?.expirationDatePickerChanged()
    }
    
    @IBAction func updateItem(_ sender: UIButton) {
        self.updateFoodHelper?.updateItem()
    }
    

}

extension UpdateFoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.updateFoodHelper!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.updateFoodHelper!.tableView(tableView, didSelectRowAt: indexPath)
    }
    
}
