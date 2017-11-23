//
//  myShopsTableViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 10/25/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase

class myShopsTableViewController: UITableViewController {

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
        let user = Auth.auth().currentUser?.uid
        ref.child("users").child(user!).child("shopsUserOwns").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                self.numRows = Int(snapshot.childrenCount)
                for item in snapshot.children {
                    self.usersShops.append(item as! DataSnapshot)
                }
            }
            self.tableView.reloadData()
        })
    }

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var numRows: Int = 0
    
    var ref: DatabaseReference!
    
    var usersShops = [DataSnapshot]()
    
    var shopToSegueTo : String!
    
    var shopNameToSegueTo : String!
    
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicShopCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = (String)(describing: usersShops[indexPath.item].key)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier != nil) {
           if segue.identifier! == "toEditShop" {
                if let navVC = segue.destination as? UINavigationController {
                    if let vc = navVC.viewControllers.first as? editShopTableViewController {
                        vc.shopReferralCode = shopToSegueTo!
                        vc.shopName = shopNameToSegueTo!
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shopToSegueTo = (String)(describing: (usersShops[indexPath.item].value)!)
        shopNameToSegueTo = usersShops[indexPath.item].key
        performSegue(withIdentifier: "toEditShop", sender: self)
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
