//
//  addItemTableViewCell.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 10/27/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit

class addItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        itemCostTextField.keyboardType = UIKeyboardType.decimalPad
    }
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemCostTextField: UITextField!
    
    
    
}
