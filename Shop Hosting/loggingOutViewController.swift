//
//  loggingOutViewController.swift
//  
//
//  Created by Seth Saperstein on 10/26/17.
//

import UIKit
import Firebase

class loggingOutViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("logging out...")
                self.dismiss(animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
                print("could not log out")
            }
        }
        self.dismiss(animated: true, completion: {
            self.presentingViewController!.dismiss(animated: false, completion: nil)
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
