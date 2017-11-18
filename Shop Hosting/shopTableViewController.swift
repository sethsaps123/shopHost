//
//  shopTableViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 10/24/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class shopTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserBelongsTo").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                self.numColumns = (Int)(snapshot.childrenCount)
                var newItems = [DataSnapshot]()
                for item in snapshot.children {
                    newItems.append(item as! DataSnapshot)
                }
                self.items = newItems
                self.tableView.reloadData()
            }
        })
        
    }
    
    var items = [DataSnapshot]()
    
    var ref: DatabaseReference!
    
    var numColumns = 0
    
    var segueToActualName : String!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func addShopSegue(_ sender: Any) {
        //not sure this needs any implementation
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
        return numColumns
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as? shopListTableViewCell
        
        // Configure the cell...
        cell?.shopReferralCode = items[indexPath.item].key
        cell?.shopName.text = (String)(describing: (items[indexPath.item].value)!)
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send info to store
        if (segue.identifier == "toStoreCheckout") {
            //set up vc for store here
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? singleShopTableViewController {
                    vc.shopName = self.storeToSegueTo
                    vc.shopActualName = self.segueToActualName
                }
            }
        }
    }
    
    var storeToSegueTo: String!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        storeToSegueTo = items[indexPath.item].key
        segueToActualName = (String)(describing: (items[indexPath.item].value)!)
        performSegue(withIdentifier: "toStoreCheckout", sender: nil)
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
