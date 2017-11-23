//
//  shopOrderTableViewCell.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 11/18/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit

class shopOrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var orderLabel: String!
    
}
