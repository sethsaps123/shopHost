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
    
    @IBAction func enterRefferalButton(_ sender: UIButton) {
        ref.child("shops").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if snapshot.hasChild(self.referralTextField.text!) {
               
                self.ref.child("shops").child(self.referralTextField.text!).observeSingleEvent(of: .value, with: {(snapshot) in
                       let value = snapshot.value as? NSDictionary
                    let shopOwner = value?["shopOwner"] as? String ?? ""
                    print(shopOwner)
                    if (shopOwner == Auth.auth().currentUser?.uid) {
                        self.referralStatusLabel.text = "Cannot add your own shop, try again"
                        print("cannot join your own shop")
                        return
                    }
                    else {
                       
                        let value = ["numOrders" : 0]
                        self.ref.child("shops").child(self.referralTextField.text!).child("shopMembers").child((Auth.auth().currentUser?.uid)!).setValue(value)
                        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("shopsUserBelongsTo").child(self.referralTextField.text!).setValue(true)
                    
                        
                        self.referralStatusLabel.text = "Shop added successfully!"
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    })
                
            }
            else {
                    self.referralStatusLabel.text = "Incorrect Referral code. Try again"
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
