//
//  storeOrdersTableViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 11/1/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase

class storeOrdersTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.title = orderName
        self.title = "User Order"
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopOrders").child(orderName).child("order").observeSingleEvent(of: .value, with: {(snapshot) in
            self.numRows = (Int)(snapshot.childrenCount) + 1
            for item in snapshot.children {
                self.orderItems.append(item as! DataSnapshot)
            }
            self.tableView.reloadData()
        })
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopOrders").child(orderName).child("deliveryDetails").observeSingleEvent(of: .value, with: {(snapshot) in
            for item in snapshot.children {
                self.addressData.append(item as! DataSnapshot)
            }
            for item in self.self.addressData {
                let tempString : String = (String)(describing: (item.value)!)
                self.orderAddress = self.orderAddress + tempString + " "
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var orderName: String!
    
    var numRows = 1
    
    var ref: DatabaseReference!
    
    var orderItems = [DataSnapshot]()
    
    var addressData = [DataSnapshot]()
    
    var phoneNumber : String!
    
    var orderAddress = "Address: "
    
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
        if indexPath.item != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleShopOrderCell", for: indexPath)
            cell.textLabel?.text = orderItems[indexPath.item - 1].key
            cell.detailTextLabel?.text = (String)(describing: (orderItems[indexPath.item - 1].value)!)
            return cell
        }
        else if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shopDescriptionShopOrder", for: indexPath)
            if let currentCell = cell as? deliveryDescriptionTableViewCell {
                currentCell.addressLabel.text = orderAddress
                currentCell.phoneLabel.text = "Phone: " + phoneNumber
                return currentCell
            }
        
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleShopOrderCell", for: indexPath)
     // Configure the cell...
     
     return cell
     }
    

    
    @IBAction func markDeliveredBarButton(_ sender: UIBarButtonItem) {
        if sender.title == "Mark as Delivered" {
            sender.title = "Delivered!"
            ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopOrders").child(orderName).updateChildValues(["delivered" : true])
        }
        else if sender.title == "Delivered!" {
            sender.title = "Mark as Delivered"
            ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopOrders").child(orderName).updateChildValues(["delivered" : false])
        }
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
