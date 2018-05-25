//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by nguyễn hữu đạt on 5/16/18.
//  Copyright © 2018 nguyễn hữu đạt. All rights reserved.
//
import UIKit

class MealTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        meal00 = DataService.shared.meals.filter({ (meal000 : Meal) -> Bool in
            return meal000.name.contains(searchController.searchBar.text!.lowercased())
            
        })
        tableView.reloadData()
    }
    
    
    var meal00 :[Meal] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Data"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
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
        if searchController.isActive{
        return meal00.count
        } else{
            return DataService.shared.meals.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else  {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Configure the cell...
        if searchController.isActive {
            cell.nameLable.text = meal00[indexPath.row].name
            cell.photoImageView.image = meal00[indexPath.row].photo
            cell.ratingControl.rating = meal00[indexPath.row].rating
        }else{
        cell.nameLable.text = DataService.shared.meals[indexPath.row].name
        cell.photoImageView.image = DataService.shared.meals[indexPath.row].photo
        cell.ratingControl.rating = DataService.shared.meals[indexPath.row].rating
    }
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewcontroller = segue.destination as? MealViewController else { return}
        if let indexpath = tableView.indexPathForSelectedRow {
            if let index = DataService.shared.meals.index(of: meal00[indexpath.row]) {
            viewcontroller.index = index
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
        switch editingStyle {
        case.delete :
        if searchController.textInputMode != nil {
            if let index = DataService.shared.meals.index(of: meal00[indexPath.row]) {
                print(index)
                DataService.shared.meals.remove(at: index)
                meal00.remove(at: indexPath.row)
                tableView.reloadData()
                
            }
        } else{
            DataService.shared.meals.remove(at: indexPath.row)
            meal00 = DataService.shared.meals
            tableView.reloadData()
            }
        case .none:
            print("hehe")
        case .insert:
            print("hihi")
        }
        
    }
    
}

