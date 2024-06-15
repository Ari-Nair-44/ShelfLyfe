//
//  FoodViewController.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/3/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {
    
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var buttonsView: UIView!

    var locationID: Int?
    var db: LocalDatabase?
    var foodHelper: FoodHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.foodTableView.delegate = self
        self.foodTableView.dataSource = self
        
        self.buttonsView.layer.cornerRadius = 5
        
        let searchController = UISearchController(searchResultsController: nil)

        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Food or Tags"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true

        self.foodHelper = FoodHelper(storyboard: self.storyboard, presentController: self, searchController: searchController, foodTableView: self.foodTableView, locationID: self.locationID!, db: self.db!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.foodHelper?.refreshFoodList()
        self.foodTableView.reloadData()
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        self.foodHelper?.addItem()
    }
    
    @IBAction func scanItem(_ sender: UIButton) {
        self.foodHelper?.scanItem()
    }
    
    
}

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.foodHelper!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.foodHelper!.tableView(tableView, cellForRowAt: indexPath)
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        self.foodHelper!.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.foodHelper?.edit(indexPath: indexPath)
        }
        edit.backgroundColor = .systemGray2
        
        let expired = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.foodHelper?.delete(indexPath: indexPath)
        }
        edit.backgroundColor = .systemGray2
        
        let configuration = UISwipeActionsConfiguration(actions: [expired, edit])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.foodHelper?.tableView(tableView, didSelectRowAt: indexPath)
    }
    
}

extension FoodViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
        self.foodHelper?.searchForFood(foodNameSearchString: text)
    }
    
}
