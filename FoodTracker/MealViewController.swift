//
//  ViewController.swift
//  FoodTracker
//
//  Created by nguyễn hữu đạt on 5/15/18.
//  Copyright © 2018 nguyễn hữu đạt. All rights reserved.
//

import  UIKit
//import os.log

class MealViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var nameTextFild: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!

    var index : Int?
    var meals = DataService.shared.meals
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let indexPath = index {
            nameTextFild.text = DataService.shared.meals[indexPath].name
            photoImageView.image = DataService.shared.meals[indexPath].photo
            ratingControl.rating = DataService.shared.meals[indexPath].rating
        }
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
        navigationItem.title = textField.text
        mealNameLabel.text = textField.text
    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextFild.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "com ga anh manh"
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    private func updateSaveButtonState() {
        let text = nameTextFild.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    @IBAction func saveTo(_ sender : UIBarButtonItem){
        nameTextFild.resignFirstResponder()
        nameTextFild.endEditing(true)
        
        guard nameTextFild.text != "" else {return}
        if let indexpath = index {
            DataService.shared.meals[indexpath].name = nameTextFild.text!
            DataService.shared.meals[indexpath].photo = photoImageView.image
            DataService.shared.meals[indexpath].rating = ratingControl.rating
        }else{
            guard let meal = Meal(name: nameTextFild.text!, photo: photoImageView.image, rating: ratingControl.rating) else {return}
            DataService.shared.addNumber(from: meal)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
}

