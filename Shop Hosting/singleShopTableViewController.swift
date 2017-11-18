//
//  singleShopTableViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 10/26/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase

class singleShopTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = shopActualName
        ref = Database.database().reference()
        populateTable()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        populateTable()
    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
    
    var ref: DatabaseReference!
    
    var numRows: Int = 1
    
    var shopName: String!
    
    var shopActualName : String!

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "storeItemTableViewCell", for: indexPath)
        let cell = newCell as! storeItemTableViewCell
        if !itemNames.isEmpty {
            cell.itemName.text = (String)(describing: itemNames[indexPath.item].key)
            cell.itemPrice.text = "$" + (String)(describing: (itemNames[indexPath.item].value)!)
        }
        
        
        return cell
    }
    
    var itemNames = [DataSnapshot]()
    
    func populateTable() {
        self.ref.child("shops").child(shopName).child("shopItems").observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.numRows = (Int)(snapshot.childrenCount)
            for item in snapshot.children {
                self.itemNames.append(item as! DataSnapshot)
            }
            self.tableView.reloadData()
        })
    }
    
    var order : [String : Int] = [:]
    
    @IBAction func checkoutButton(_ sender: UIBarButtonItem) {
        order = getCellsData()
        if order.isEmpty {
            let refreshAlert = UIAlertController(title: "Cannot checkout", message: "Must have at least 1 item selected", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "toDeliveryDetail", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDeliveryDetail" {
            if let vc = segue.destination as? deliveryDetailViewController {
                vc.shopName = shopName
                vc.order = order
            }
        }
    }
    
    func getCellsData()->[String : Int] {
        var dataDictionary: [String : Int] = [:]
        for section in 0 ..< self.tableView.numberOfSections {
            for row in 0 ..< self.tableView.numberOfRows(inSection: section) {
                let indexPath = NSIndexPath(row: row, section: section)
                
                let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! storeItemTableViewCell
                if cell.itemCount > 0 {
                    dataDictionary[cell.itemName.text!] = (Int)(cell.itemCount)
                }
            }
        }
        return dataDictionary
    }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
