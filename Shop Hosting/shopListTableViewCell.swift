//
//  shopListTableViewCell.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 11/7/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit

class shopListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var shopName: UILabel!
    
    var shopReferralCode : String!

}
