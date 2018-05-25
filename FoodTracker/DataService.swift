//
//  DataService.swift
//  FoodTracker
//
//  Created by nguyễn hữu đạt on 5/25/18.
//  Copyright © 2018 nguyễn hữu đạt. All rights reserved.
//

import UIKit

class DataService {
    static let shared: DataService = DataService()
    
    private var _meals: [Meal]?
    var meals: [Meal]{
        get {
            if _meals == nil {
                loadSampleMeal()
            }
            return _meals ?? []
        }
        set {
            _meals = newValue
        }
    }
    private func loadSampleMeal() {
        _meals = []
        guard let meal1 = Meal(name: "Caprese Salad", photo: UIImage(named: "meal1"), rating: 4) else {return}
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: #imageLiteral(resourceName: "meal2"), rating: 5) else {return}
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: #imageLiteral(resourceName: "meal3"), rating: 3) else {return}
        _meals = [meal1,meal2,meal3]
    }
    
}
