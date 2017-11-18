//
//  referralViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 10/25/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class referralViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var ref: DatabaseReference!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var referralTextField: UITextField!
    
    var shopName: String!
    
    @IBAction func enterRefferalButton(_ sender: UIButton) {
        ref.child("shops").child(self.referralTextField.text!).observeSingleEvent(of: .value, with: {(snapshot) in
            //if the shop doesn't exist
            if !snapshot.exists() {
                self.referralStatusLabel.text = "Shop does not exist"
                return
            }
                //if the shop exists and already has shopMembers node
            else if snapshot.hasChild("shopMembers") {
                //check if the user already owns this shop
                if let dict = snapshot.value as? [String : AnyObject] {
                    if let owner = dict["shopOwner"] as? String {
                        if owner == Auth.auth().currentUser?.uid {
                            self.referralStatusLabel.text = "Cannot add your own shop"
                            return
                        }
                    }
                    if let name = dict["shopName"] as? String {
                        self.shopName = name
                    }
                }
                //snapshot shop members
                    self.ref.child("shops").child(self.referralTextField.text!).child("shopMembers").observeSingleEvent(of: .value, with: {(snapshot) in
                        //if the user is already a members
                        if snapshot.hasChild((Auth.auth().currentUser?.uid)!) {
                            self.referralStatusLabel.text = "This shop has already been added"
                        }
                            //if the user is not already a member
                        else {
                           //set the value of the member as the user
                            self.ref.child("shops").child(self.referralTextField.text!).child("shopMembers").child((Auth.auth().currentUser?.uid)!).setValue(["numOrders" : 0])
                            //check if the user already belongs to any shops
                            self.addShopToUsersShops()
                            self.dismiss(animated: true, completion: nil)
                            return
                        }
                    })
            }
                //if the shop does not already have shop members, add node w user
            else {
                //check if the user already owns this shop
                if let dict = snapshot.value as? [String : AnyObject] {
                    if let owner = dict["shopOwner"] as? String {
                        if owner == Auth.auth().currentUser?.uid {
                            self.referralStatusLabel.text = "Cannot add your own shop"
                            return
                        }
                    }
                    if let name = dict["shopName"] as? String {
                        self.shopName = name
                    }
                }
                self.ref.child("shops").child(self.referralTextField.text!).child("shopMembers").child((Auth.auth().currentUser?.uid)!).setValue(["numOrders" : 0])
                self.addShopToUsersShops()
                self.dismiss(animated: true, completion: nil)
                return
            }
            
        })
    }
        
    func addShopToUsersShops() {
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserBelongsTo").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                //if the user belongs to a shop, update the value
                self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserBelongsTo").updateChildValues([self.referralTextField.text! : self.shopName])
            }
                //if the user does not already belong to a shop
            else {
                self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserBelongsTo").setValue([self.referralTextField.text! : self.shopName])
            }
        })
    }
    
    
        
    @IBOutlet weak var referralStatusLabel: UILabel!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
