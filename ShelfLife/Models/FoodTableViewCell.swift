//
//  FoodTableViewCell.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/3/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    //@IBOutlet weak var cellView: UIView!
    @IBOutlet weak var foodIconImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView! {
        didSet {
            // Make it card-like
            self.cellView.layer.cornerRadius = 5
            self.cellView.layer.shadowOpacity = 0.3
            self.cellView.layer.shadowRadius = 3
            
            self.cellView.layer.shadowColor = UIColor(named: "Gray")?.cgColor
            self.cellView.layer.shadowOffset = CGSize(width: 3, height: 3)
            
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

