//
//  createShopTableViewController.swift
//  
//
//  Created by Seth Saperstein on 10/26/17.
//

import UIKit
import Firebase

class createShopTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        ref = Database.database().reference()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
        
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var ref: DatabaseReference!
    
    @IBAction func createShop(_ sender: UIBarButtonItem) {
        
        let referralCode = randomAlphaNumericString(length: 10)
        let values = ["shopOwner" : Auth.auth().currentUser!.uid,
                      "shopName" : shopName]
        let itemData = getCellsData()
        
        let values2 = [shopName : true]
        self.ref.child("shops").child(referralCode).setValue(values)
        
        self.ref.child("shops").child(referralCode).child("shopItems").setValue(itemData)
        
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserOwns").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserOwns").updateChildValues(values2)
            }
            else {
                self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserOwns").setValue(values2)
            }
        })
        //self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserOwns").setValue(values2)
        
        let alertController = UIAlertController(title: "Shop Added", message: "Here is your referral code: \(referralCode)", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        numRows += 1
        tableView.reloadData()
    }
    
    var numRows = 2
    
    var shopName: String!
    
    func getCellsData()->[String : Double] {
        var dataDictionary: [String : Double] = [:]
        for section in 0 ..< self.tableView.numberOfSections {
            for row in 0 ..< self.tableView.numberOfRows(inSection: section) {
                let indexPath = NSIndexPath(row: row, section: section)
                if row != 0 {
                    let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! addItemTableViewCell
     
                    dataDictionary[cell.itemNameTextField.text!] = (Double)(cell.itemCostTextField.text!)
                }
                else {
                    let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! shopTitleTableTableViewCell
                    self.shopName = cell.shopNameTextField.text!
                }
            }
        }
        return dataDictionary
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
        var identifier: String!
        if indexPath.item > 0 {
            identifier = "addItemTableViewCell"
        }
        else if indexPath.item == 0 {
            identifier = "shopTitleTableViewCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        return cell
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
