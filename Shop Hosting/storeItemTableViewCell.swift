//
//  storeItemTableViewCell.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 10/26/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit

class storeItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBAction func plusItem(_ sender: UIButton) {
        itemCount += 1
    }
    @IBAction func minusItem(_ sender: UIButton) {
        itemCount -= 1
    }
    
    var itemCount = 0 {
        didSet {
            numItem.text = "\(itemCount)"
        }
    }
    
    @IBOutlet weak var numItem: UILabel!
    
}
