//
//  RatingPresent.swift
//  MyPlaces
//
//  Created by Oleg on 10/29/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class RatingPresent: UIStackView {
    
    
    // MARK: Properties
    
    var rating = 0 {
        didSet {
            setupButtons()
        }
    }
    

    
    private var ratingButtons = [UIView]()
    
    var starSize: CGSize = CGSize(width: 20.0, height: 20.0)
    
    @IBInspectable var starCount: Int = 5

    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    

    
    // MARK: Private Methods
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }

        ratingButtons.removeAll()
        
        for i in 0..<starCount {
            
            // Create the button
            var starView = UIImageView()
            
            if rating >= i + 1 {
                starView = UIImageView(image: #imageLiteral(resourceName: "filledStar"))
            } else {
                starView = UIImageView(image: #imageLiteral(resourceName: "emptyStar"))
            }
            starView.translatesAutoresizingMaskIntoConstraints = false
            starView.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            starView.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            // Add the button to the stack
            addArrangedSubview(starView)
            
            // Add the new button on the rating button array
            ratingButtons.append(starView)
        }
    }

}
