//
//  ViewController.swift
//  A252HelloFirebase02
//
//  Created by 申潤五 on 2025/3/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class ViewController: UIViewController {
    
    var credential: AuthCredential?

    @IBOutlet weak var gidSignInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        Auth.auth().signInAnonymously { authResult, error in
//          // ...
//        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print(user.email ?? "---")
                print(user.uid ?? "****")
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

    @IBAction func doSingIn(_ sender: GIDSignInButton) {
        googleSignIn()
    }
    
    func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            // ...
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }
            
            self.credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                            accessToken: user.accessToken.tokenString)
            if let credential = self.credential {
                Auth.auth().signIn(with: credential) { result, error in
                    if let error{
                        print(error.localizedDescription)
                    }
                }
            }

          // ...
        }
    }
    
    
    

}

