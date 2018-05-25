//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by nguyễn hữu đạt on 5/16/18.
//  Copyright © 2018 nguyễn hữu đạt. All rights reserved.
//
import UIKit

class MealTableViewController: UITableViewController {
    

    
    var meals : [Meal] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
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
                }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return DataService.shared.meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else  {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Configure the cell...
        cell.nameLable.text = DataService.shared.meals[indexPath.row].name
        cell.photoImageView.image = DataService.shared.meals[indexPath.row].photo
        cell.ratingControl.rating = DataService.shared.meals[indexPath.row].rating

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewcontroller = segue.destination as? MealViewController else { return}
            if let indexpath = tableView.indexPathForSelectedRow {
//                if let index = DataService.shared.meals[indexpath.row] {
                    viewcontroller.index = indexpath.row
                
        }
//            }
        
        
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
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
}
