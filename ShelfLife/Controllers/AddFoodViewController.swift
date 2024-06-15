//
//  AddFoodViewController.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/6/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class AddFoodViewController: UIViewController {

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var expirationDatePicker: UIDatePicker! {
        didSet {
            if #available(iOS 13.4, *) {
                self.expirationDatePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBOutlet weak var addItemButton: UIButton! {
        didSet {
         
            self.addItemButton.layer.cornerRadius = 5
            
        }
    }
    
        
    var locationList: [Location] = []
    var db: LocalDatabase?
    var addFoodHelper: AddFoodHelper?
    var locationID: Int?
    var foodName: String?
    var tags: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.foodNameTextField.clearButtonMode = .whileEditing
        self.tagsTextField.clearButtonMode = .whileEditing
        
        if self.locationList.isEmpty {
            self.locationList = self.db!.readTableLocation()
        }
        
        if let item = self.foodName {
            self.foodNameTextField.text = item
        }
        
        self.addFoodHelper = AddFoodHelper(viewController: self, storyboard: self.storyboard!, foodTextField: self.foodNameTextField, tagsTextField: self.tagsTextField, expirationLabel: self.expirationLabel, expirationDatePicker: self.expirationDatePicker, db: self.db!, locationList: self.locationList, locationID: self.locationID)
        
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    @IBAction func quantityStepperChanged(_ sender: UIStepper) {
        self.quantityLabel.text = "\(Int(sender.value))"
        self.addFoodHelper?.quantity = Int(sender.value)
    }
    
    @IBAction func expirationDatePickerChanged(_ sender: UIDatePicker) {
        self.addFoodHelper?.expirationDatePickerChanged()
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        self.addFoodHelper?.addItem()
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
    

}

extension AddFoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.addFoodHelper!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addFoodHelper?.tableView(tableView, didSelectRowAt: indexPath)
    }
    
}
