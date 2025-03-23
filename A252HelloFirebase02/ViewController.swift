//
//  ViewController.swift
//  A252HelloFirebase02
//
//  Created by 申潤五 on 2025/3/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FacebookLogin

class ViewController: UIViewController {
    
    var credential: AuthCredential?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        Auth.auth().signInAnonymously { authResult, error in
//          // ...
//        }
        
//        let loginButton = FBSDKLoginButton()
//        loginButton.delegate = self
        let loginButton = FBLoginButton()
        loginButton.center = view.center
//        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print(user.email ?? "---")
                print(user.uid ?? "****")
                // end google Login
            } else {
                print("logout")
            }
        }
    }
    
    
    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch{
            print(error.localizedDescription)
        }
    }


    
    
    
    
    

}

