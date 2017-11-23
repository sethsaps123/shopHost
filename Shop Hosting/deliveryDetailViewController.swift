//
//  deliveryDetailViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 11/6/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase

class deliveryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var shopName: String!
    
    var order: [String : Int]!
    
    @IBOutlet weak var deliveryAddressTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var ref : DatabaseReference!
    
    @IBOutlet weak var warningMessage: UILabel!
    
    
    @IBAction func checkoutButton(_ sender: UIBarButtonItem) {
        if (!(deliveryAddressTextField.text?.isEmpty)! && !(cityTextField.text?.isEmpty)!
            && !(stateTextField.text?.isEmpty)! && !(zipTextField.text?.isEmpty)!) {
        
        let confirmAlert = UIAlertController(title: "Checkout", message: "Are you sure you would like to checkout?", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //handle ok actions here
            let time = Date.init().description
            let addressDetails = ["address" : self.deliveryAddressTextField.text!,
                                  "city" : self.cityTextField.text!,
                                  "state" : self.stateTextField.text!,
                                  "zip" : self.zipTextField.text!]
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("userOrders").child(time).setValue(self.order)
            
            
            //get current shop owner to set his current shop orders
            self.ref.child("shops").child(self.shopName).observeSingleEvent(of: .value, with: {(snapshot) in
                if let dict = snapshot.value as? [String : AnyObject] {
                    if let shopOwner = dict["shopOwner"] as? String {
                        self.ref.child("users").child(shopOwner).child("shopOrders").child((Auth.auth().currentUser?.uid)! + time).child("order").setValue(self.order)
                        
                        self.ref.child("users").child(shopOwner).child("shopOrders").child((Auth.auth().currentUser?.uid)! + time).child("time").setValue(time)
                        
                        self.ref.child("users").child(shopOwner).child("shopOrders").child((Auth.auth().currentUser?.uid)! + time).updateChildValues(["delivered" : false])
                        
                        self.ref.child("users").child(shopOwner).child("shopOrders").child((Auth.auth().currentUser?.uid)! + time).child("deliveryDetails").setValue(addressDetails)
                        
                        self.ref.child("users").child(shopOwner).child("shopOrders").child((Auth.auth().currentUser?.uid)! + time).updateChildValues(["phoneNumber" : self.phoneNumberTextField.text!])
                        
                    }
                }
                self.dismiss(animated: true, completion: nil)
            })
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(confirmAlert, animated: true, completion: nil)
        }
        else {
            warningMessage.text = "All fields must be filled out"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
