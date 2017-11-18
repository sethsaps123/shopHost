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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: frame.width, height: 60)
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        textFieldEmail.alpha = 0.4
        textFieldPassword.alpha = 0.4
        phoneNumberTextField.alpha = 0.4
        passwordAgainTextField.alpha = 0.4
        
        emailIconImage.image = UIImage(named: "key.png")
        againPasswordImage.image = UIImage(named: "lock.png")
        numberImage.image = UIImage(named: "phone.png")
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "detroitSkylineEdit.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var emailIconImage: UIImageView!
    @IBOutlet weak var againPasswordImage: UIImageView!
    @IBOutlet weak var numberImage: UIImageView!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonRegister(_ sender: UIButton) {
        sender.alpha = 0.8
        let email = textFieldEmail.text
        let password = textFieldPassword.text
        let phoneNumber = phoneNumberTextField.text
        
        if (email != "" && password != "") {
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user: User?, error) in
                if error == nil {
                    self.labelMessage.text = "You are successfully registered"
                    let values = ["email": email!, "password": password!, "phone": phoneNumber!]
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

