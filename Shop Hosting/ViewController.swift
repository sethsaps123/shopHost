//
//  ViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 10/20/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBAction func buttonRegister(_ sender: UIButton) {
        let email = textFieldEmail.text
        let password = textFieldPassword.text
        
        if (email != "" && password != "") {
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user: User?, error) in
                if error == nil {
                    self.labelMessage.text = "You are successfully registered"
                    let values = ["email": email!, "password": password!]
                self.ref.child("users").child((user?.uid)!).setValue(values)
                    
                    self.performSegue(withIdentifier: "createdNewUserToShop", sender: nil)
                }else{
                    self.labelMessage.text = "Registration Failed.. Please Try Again"
                }
                
            })
        }
        else {
            self.labelMessage.text = "Please enter a valid email and password"
        }
        
    }
    
    
    
}

