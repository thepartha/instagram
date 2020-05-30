//
//  ViewController.swift
//  instagram
//
//  Created by Partha Sarathy on 5/28/20.
//  Copyright © 2020 Partha Sarathy. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupModeActive = true
    
    func displayAlert(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                   
                   alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                       self.dismiss(animated: true, completion: nil)
                   }))
                   
                   self.present(alertViewController, animated: true, completion: nil)
    }
    

    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet var signupOrLoginButton: UIButton!
    
    @IBAction func signupOrLoginButton(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            displayAlert(title: "Error", message: "You forgot to enter an emailaddress or password")
            
        } else {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.style = UIActivityIndicatorView.Style.medium
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            view.isUserInteractionEnabled = false
            
            if signupModeActive {
                let user = PFUser()
                if let email = emailTextField?.text, let password = passwordTextField?.text {
                    user.password = password
                    user.username = email
                }
                // other fields can be set just like with PFObject
                
                
                user.signUpInBackground { (succeess, error) in
                    
                    activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    if let safeError = error {
                        self.displayAlert(title: "Could not Sign you up!", message: safeError.localizedDescription)
                    } else {
                        print("Sign up Success")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                }
                
            } else {
                if let email = emailTextField?.text, let password = passwordTextField?.text {
                    PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
                        
                        activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        if user != nil {
                            self.performSegue(withIdentifier: "showUserTable", sender: self)
                        } else {
                            if let safeError = error {
                                self.displayAlert(title: "Failure", message: safeError.localizedDescription)
                            }
                            
                        }
                    }
                }
                
                
            }
            
            
        }
    }
      
    @IBAction func switchLoginMode(_ sender: Any) {
        if signupModeActive {
            
            signupModeActive = false
            
            signupOrLoginButton.setTitle("Log In", for: [])
            
            switchLoginModeButton.setTitle("Sign Up", for: [])
        } else {
            
            signupModeActive = true
            
            signupOrLoginButton.setTitle("Sign up", for: [])
            
            switchLoginModeButton.setTitle("Log In", for: [])
            
        }
    }
    
    @IBOutlet var switchLoginModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if PFUser.current() != nil {
        self.performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
            
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserTable" {
            let vc = segue.destination as? UserTableViewController
            vc?.modalPresentationStyle = .fullScreen
        }
    }


}

