//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by nguyễn hữu đạt on 5/16/18.
//  Copyright © 2018 nguyễn hữu đạt. All rights reserved.
//
import UIKit
import os.log

class MealTableViewController: UITableViewController,UISearchBarDelegate {
    
@IBOutlet weak var searchBar: UISearchBar!
    var isSearchActive : Bool = false
    var meals = [Meal]()
    var meal0 = [Meal]()
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        meals += [meal1,meal2,meal3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
        loadSampleMeals()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                
            
            // Add a new meal.
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            
            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
            saveMeals()
    }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return meal0.count
        } else {
            return meals.count
        }
}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"

      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else  {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        if isSearchActive {
            let meal00 = meal0[indexPath.row]
            cell.nameLable.text = meal00.name
            cell.photoImageView.image = meal00.photo
            cell.ratingControl.rating = meal00.rating
//            cell.nameLable.text = meals
        } else {
        let meal = meals[indexPath.row]
        
        cell.nameLable.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        }
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

        }
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        meal0 = meals.filter({ (text) -> Bool in
            let tmp: NSString = text.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if (meal0.count == 0){
            if searchText.isEmpty{
                isSearchActive = false}
            else{isSearchActive = true }
        }
            else{
            isSearchActive = true
        }
        self.tableView.reloadData()
    }
    
    
}
