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
    var meal : Meal?
    var index : Int?
    var meals = DataService.shared.meals
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let indexPath = index {
            nameTextFild.text = DataService.shared.meals[index ?? 0].name
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
}

