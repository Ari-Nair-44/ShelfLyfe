//
//  AddLocationViewController.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/5/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    var addLocationHelper: AddLocationHelper?
    var locationList: [Location] = []
    var db: LocalDatabase?
    var locationCategoryList: [LocationCategory]?
    
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var fridgeIconImageView: UIImageView!
    @IBOutlet weak var freezerIconImageView: UIImageView!
    @IBOutlet weak var pantryIconImageView: UIImageView!
    @IBOutlet weak var otherIconImageView: UIImageView!
    @IBOutlet weak var addLocationButton: UIButton! {
        didSet {
            self.addLocationButton.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.locationNameTextField.clearButtonMode = .whileEditing
        
        self.addLocationHelper = AddLocationHelper(viewController: self, storyboard: self.storyboard!, locationNameTextField: self.locationNameTextField, fridgeIconImageView: self.fridgeIconImageView, freezerIconImageView: self.freezerIconImageView, pantryIconImageView: self.pantryIconImageView, otherIconImageView: self.otherIconImageView, locationList: self.locationList, locationCategoryList: self.locationCategoryList!, db: self.db!)

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func addLocation(_ sender: UIButton) {
        self.addLocationHelper?.addLocation()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func fridgeClicked(_ sender: UITapGestureRecognizer) {
        self.addLocationHelper?.fridgeClicked()
    }
    
    @IBAction func freezerClicked(_ sender: UITapGestureRecognizer) {
        self.addLocationHelper?.freezerClicked()
    }
    
    @IBAction func pantryClicked(_ sender: UITapGestureRecognizer) {
        self.addLocationHelper?.pantryClicked()
    }
    
    @IBAction func otherClicked(_ sender: UITapGestureRecognizer) {
        self.addLocationHelper?.otherClicked()
    }
    
}
