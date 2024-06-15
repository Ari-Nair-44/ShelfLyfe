//
//  LocationTableViewCell.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/2/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationTitleLabel: UILabel!
    
    @IBOutlet weak var firstFoodLabel: UILabel!
    @IBOutlet weak var secondFoodLabel: UILabel!
    @IBOutlet weak var thirdFoodLabel: UILabel!
    
    @IBOutlet weak var firstExpirationLabel: UILabel!
    @IBOutlet weak var secondExpirationLabel: UILabel!
    @IBOutlet weak var thirdExpirationLabel: UILabel!
    
    @IBOutlet weak var locationIconImageView: UIImageView!
    
    @IBOutlet weak var cellView: UIView! {
        didSet {
            // Make it card-like
            self.cellView.layer.cornerRadius = 5
            self.cellView.layer.shadowOpacity = 0.5
            self.cellView.layer.shadowRadius = 3
            
            self.cellView.layer.shadowColor = UIColor(named: "Gray")?.cgColor
            self.cellView.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.cellView.layer.cornerRadius = 20
        
        // Initialization code
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
