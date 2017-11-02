//
//  loginViewController.swift
//  Shop Hosting
//
//  Created by Seth Saperstein on 10/24/17.
//  Copyright © 2017 Seth Saperstein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class loginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "detroitSkyline.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        self.emailLogin.alpha = 0.5
        self.passwordLogin.alpha = 0.5
        self.appNameLabel.textColor = UIColor.white
        self.appDetailLabel.textColor = UIColor.white
        self.noAccountLabel.textColor = UIColor.white
        /*
        backgroundImage.image = backgroundImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backgroundImage.tintColor = UIColor.blue
 */
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appDetailLabel: UILabel!
    @IBOutlet weak var noAccountLabel: UILabel!
    
    @IBAction func signIn(_ sender: UIButton) {
        
        if (self.emailLogin.text == "" || self.passwordLogin.text == "") {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailLogin.text!, password: self.passwordLogin.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    self.performSegue(withIdentifier: "toShops", sender: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func cancelLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var emailLogin: UITextField!
    
    @IBOutlet weak var passwordLogin: UITextField!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
