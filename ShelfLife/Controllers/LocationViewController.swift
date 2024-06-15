//
//  ViewController.swift
//  ShelfLife
//
//  Created by Dev User1 on 6/28/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var buttonsView: UIView! {
        didSet {
            self.buttonsView.layer.cornerRadius = 5
        }
    }
    
    var locationHelper: LocationHelper?
    //var db: LocalDatabase?
    let searchController = UISearchController(searchResultsController: nil)
    //var locationList: [Location] = []
    //var locationCategoryList: [LocationCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print("viewDidLoad")
        // Do any additional setup after loading the view.
        //db = LocalDatabase()
        
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
        
        self.locationTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.locationHelper = LocationHelper(storyboard: self.storyboard, presentController: self, searchController: searchController, foodLocationTableView: self.locationTableView)
              
        //self.locationHelper?.db!.getRowCount(tableName: "food")

    }
    
    func getData() {
//        self.locationCategoryList = self.db!.readTableLocationCategory()
//        self.locationList = self.db!.readTableLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Food or Tags"

        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        //self.locationHelper?.searchController = self.searchController
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        self.locationHelper?.refreshLocationList()
        self.locationTableView.reloadData()
    }

    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        self.locationHelper?.addLocation()
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        self.locationHelper?.addItem()
    }
    
    @IBAction func scanItem(_ sender: UIButton) {
        self.locationHelper?.scanItem()
    }
    
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.locationHelper!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.locationHelper!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.locationHelper!.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.locationHelper!.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    
}

extension LocationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {

        guard let text = searchController.searchBar.text else { return }
        print(text)
        
        self.locationHelper?.searchForFoodInStorage(foodNameSearchString: text)
        
    }
    
}
