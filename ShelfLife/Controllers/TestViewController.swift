//
//  TestViewController.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/7/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
  
    var db: LocalDatabase?
    var locationList: [Location] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        
        //self.locationList = self.db.readTableLocation()
        // Do any additional setup after loading the view.
    }
  


}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFoodCellIdentifier", for: indexPath) as! AddFoodTableViewCell
        cell.locationLabel.text = self.locationList[indexPath.row].locationName
        
        if self.locationList[indexPath.row].locationCategoryID == 1 {
            
            cell.iconImageView.image = UIImage(named: "icon-fridge-light")
            
        } else if self.locationList[indexPath.row].locationCategoryID == 2 {
            
            cell.iconImageView.image = UIImage(named: "icon-freezer-light")
            
        } else if self.locationList[indexPath.row].locationCategoryID == 3 {
            
            cell.iconImageView.image = UIImage(named: "icon-pantry-light")
            
        } else if self.locationList[indexPath.row].locationCategoryID == 4 {
            cell.iconImageView.image = UIImage(named: "icon-other-light")
        } else {
            print("failed")
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test")
    }
    
    
    
    
}
