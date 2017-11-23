//
//  editShopTableViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 11/20/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase

struct itemDetails {
    init (name_: String, price_: String) {
        name = name_
        price = price_
    }
    init () {
        name = "name"
        price = "price"
    }
    var name : String
    var price : String
}

class editShopTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        ref = Database.database().reference()
        editMode = false
        ref.child("shops").child(shopReferralCode!).child("shopItems").observeSingleEvent(of: .value, with: {(snapshot) in
            for item in snapshot.children {
                self.shopData.append(item as! DataSnapshot)
            }
            self.numRows = (Int)(snapshot.childrenCount) + 1
            for item in self.shopData {
                let newItem = itemDetails(name_: item.key, price_: (String)(describing: (item.value)!))
                self.shopItems.append(newItem)
            }
            self.tableView.reloadData()
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    var editMode = false
    
    var ref : DatabaseReference!
    
    var shopReferralCode : String!
    
    var numRows = 1
    
    var shopData = [DataSnapshot]()
    
    var shopItems : [itemDetails] = []
    
    var shopName : String!
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        numRows += 1
        let newItem = itemDetails()
        shopItems.append(newItem)
        self.tableView.reloadData()
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func editSaveBarButton(_ sender: UIBarButtonItem) {
        if editMode {
            //save the changed data
            var validItems = true
            let itemDict = getCellsData()
            for item in itemDict {
                if item.key == "" || item.value == "" {
                    let alert = UIAlertController(title: "Error", message: "All fields not filled", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    validItems = false
                    break
                }
            }
            if validItems {
        
                ref.child("shops").child(shopReferralCode!).child("shopItems").setValue(itemDict)
            }
            sender.title = "Edit"
        }
        else if !editMode {
            sender.title = "Save"
        }
        editMode = !editMode
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editShop", for: indexPath)
            if let currentCell = cell as? editShopTableViewCell {
                currentCell.shopNameLabel.text = shopName
                currentCell.shopReferralCodeLabel.text = "Referral code: " + shopReferralCode
            //TO DO: set image here
                return currentCell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editItem", for: indexPath)
            if let currentCell = cell as? singleItemEditableTableViewCell {
                currentCell.itemName.text = shopItems[indexPath.item - 1].name
                currentCell.itemPrice.text = shopItems[indexPath.item - 1].price
                return currentCell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        //should never reach this
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.item != 0 {
            if editMode {
                return true
            }
            else {
                return false
            }
        }
        return false
    }
 

    
    // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            numRows -= 1
            shopItems.remove(at: indexPath.item - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        /*else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            let newItem = itemDetails()
            shopItems.append(newItem)
            numRows += 1
            
        }
         */
        self.tableView.reloadData()
    }
    
    func getCellsData()->[String : String] {
        var dataDictionary: [String : String] = [:]
        for section in 0 ..< self.tableView.numberOfSections {
            for row in 1 ..< self.tableView.numberOfRows(inSection: section) {
                let indexPath = NSIndexPath(row: row, section: section)
                
                let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! singleItemEditableTableViewCell
                dataDictionary[cell.itemName.text!] = cell.itemPrice.text!
            }
        }
        return dataDictionary
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
