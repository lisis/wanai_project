//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Ivan Leider on 22/05/2017.
//  Copyright © 2017 BTS. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var db: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.delegate = self
        
        if let user = Auth.auth().currentUser {
            performSegue(withIdentifier: "RegisterToMain", sender: nil)
        }
        db = Database.database().reference()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Facebook Error \(error)")
            return
        }
        
        print("isCancelled: \(result.isCancelled)")
        print("declined permissions: \(result.declinedPermissions)")
        print("granted permissions: \(result.grantedPermissions)")
        
        if !result.isCancelled {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Firebase error \(error)")
                    self.showMessage(message: "Something went wrong")
                } else {
                    self.performSegue(withIdentifier: "RegisterToMain", sender: nil)
                }
            })
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let user = user {
                    
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = self.nameTextField.text ?? ""
                    changeRequest.commitChanges(completion: nil)
                    
                    let userInfo = ["uid": user.uid,
                                    "name": self.nameTextField.text ?? "",
                                    "age": self.ageTextField.text ?? ""
                    ]
                    self.db.child("users").child(user.uid).setValue(userInfo)
                    
                    self.performSegue(withIdentifier: "RegisterToMain", sender: nil)
                    print("user: \(user)")
                } else {
                    self.showMessage(message: "Something went wrong")
                    print("error: \(error)")
                }
            }
        }
    }
    
    func showMessage(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
