//
//  AddFoodTableViewCell.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/7/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class AddFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView! {
        didSet {
            // Make it card-like
            self.cellView.layer.cornerRadius = 5
            self.cellView.layer.shadowOpacity = 0.2
            self.cellView.layer.shadowRadius = 1
            
            self.cellView.layer.shadowColor = UIColor(named: "Gray")?.cgColor
            self.cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
            
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
