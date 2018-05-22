//
//  RatingControl.swift
//  FoodTracker
//
//  Created by nguyễn hữu đạt on 5/15/18.
//  Copyright © 2018 nguyễn hữu đạt. All rights reserved.
//

import UIKit
@IBDesignable class RatingControl: UIStackView {
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
            
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButton()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        for _ in 0..<starCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            button.backgroundColor = UIColor.red
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    //MARK: Button Action
    @objc func ratingButtonTapped(button :UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
            print("Button pressed 👍")
            
        }
    }
}
