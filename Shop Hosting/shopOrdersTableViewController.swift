//
//  shopOrdersTableViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 11/1/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase

func substring(string: String, fromIndex: Int, toIndex: Int) -> String? {
    if fromIndex < toIndex && toIndex < string.count /*use string.characters.count for swift3*/{
        let startIndex = string.index(string.startIndex, offsetBy: fromIndex)
        let endIndex = string.index(string.startIndex, offsetBy: toIndex)
        return String(string[startIndex..<endIndex])
    }else{
        return nil
    }
}

class shopOrdersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        ref = Database.database().reference()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        time = Date.init().description
        monthDay = substring(string: time, fromIndex: 5, toIndex: 10)
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopOrders").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                self.numRows = (Int)(snapshot.childrenCount)
                var items = [DataSnapshot]()
                for item in snapshot.children {
                    items.append(item as! DataSnapshot)
                }
                self.myOrders = items
                self.tableView.reloadData()
            }
        })
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopOrders").observeSingleEvent(of: .value, with: {(snapshot) in
            let times = snapshot
                .children
                .flatMap { $0 as? DataSnapshot }
                .flatMap { $0.value as? [String:Any] }
                .flatMap { $0["time"] as? String }
            self.orderTimes = times
            let numbers = snapshot
                .children
                .flatMap { $0 as? DataSnapshot }
                .flatMap { $0.value as? [String:Any] }
                .flatMap { $0["phoneNumber"] as? String }
            self.orderNumbers = numbers
        })
    }

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var ref: DatabaseReference!
    
    var myOrders = [DataSnapshot]()
    
    var orderTimes : [String]!
    
    var orderNumbers: [String]!
    
    var numRows = 0
    
    var time = Date.init().description
    
    var monthDay : String!
    
    var phoneNumberToSegueTo : String!
    
    var editedPhoneNumbers : [String] = []
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myOrderCells", for: indexPath)
        if let currentCell = cell as? shopOrderTableViewCell {
            let shopLabel = myOrders[indexPath.item].key
            currentCell.orderLabel = shopLabel
            var phoneNumber = orderNumbers[indexPath.item]
            phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.startIndex, offsetBy: (3)))
            phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.startIndex, offsetBy: (7)))
            currentCell.phoneNumber.text = phoneNumber
            editedPhoneNumbers.append(phoneNumber)
            let time = orderTimes[indexPath.item]
            let adjustedTime = substring(string: time, fromIndex: 5, toIndex: 10)
            if monthDay == adjustedTime {
                var adjustedHours = (Int)((substring(string: adjustedTime!, fromIndex: 0, toIndex: 2))!)
                if adjustedHours! >= 12 {
                    adjustedHours! -= 12
                    currentCell.timeLabel.text = (String)(describing: adjustedHours!) + substring(string: adjustedTime!, fromIndex: 2, toIndex: 5)! + " am"
                }
                else {
                    currentCell.timeLabel.text = substring(string: time, fromIndex: 11, toIndex: 16)! + " pm"
                }
            }
            else {
                currentCell.timeLabel.text = adjustedTime
            }
        }
        return cell
    }
    
    var orderToSegueTo: String!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrder" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? storeOrdersTableViewController {
                    vc.orderName = self.orderToSegueTo
                    vc.phoneNumber = self.phoneNumberToSegueTo
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderToSegueTo = myOrders[indexPath.item].key
        phoneNumberToSegueTo = editedPhoneNumbers[indexPath.item]
        performSegue(withIdentifier: "toOrder", sender: nil)
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
