//
//  singleItemEditableTableViewCell.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 11/21/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit

class singleItemEditableTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var itemPrice: UITextField!
}
