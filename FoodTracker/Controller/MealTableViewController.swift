//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by nguyễn hữu đạt on 5/16/18.
//  Copyright © 2018 nguyễn hữu đạt. All rights reserved.
//
import UIKit
import os.log

class MealTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return  }
        meals = searchText.isEmpty ? (DataService.shared.meals) : DataService.shared.meals.filter({ (meal : Meal) -> Bool in
            return meal.name.lowercased().contains(searchText.lowercased())
            
        })
        tableView.reloadData()
    }
    
    
    var meals : [Meal] = []
    var searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Data"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        meals = DataService.shared.meals
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else  {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        cell.nameLable.text = meals[indexPath.row].name
        cell.photoImageView.image = meals[indexPath.row].photo
        cell.ratingControl.rating = meals[indexPath.row].rating
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mealViewcontroller = segue.destination as? MealViewController else {return}
        if let indexpath = tableView.indexPathForSelectedRow {
            if let index = DataService.shared.meals.index(of: meals[indexpath.row]) {
                mealViewcontroller.index = index
            }
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle  == .delete {
            if let index = DataService.shared.meals.index(of: meals[indexPath.row]) {
                DataService.shared.meals.remove(at: index)
                meals.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
}

