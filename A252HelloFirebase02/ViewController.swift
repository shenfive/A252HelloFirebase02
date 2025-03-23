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
import CryptoKit

class ViewController: UIViewController {

    
    var credential: AuthCredential?

    var currentNonce = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        Auth.auth().signInAnonymously { authResult, error in
//          // ...
//        }
        

        
        let loginButton = FBLoginButton()
        loginButton.center = view.center
//        loginButton.permissions = ["public_profile", "email"]
        loginButton.delegate = self
        
        let nonce = randomNonceString()
        currentNonce = nonce
     
        loginButton.loginTracking = .limited
        loginButton.nonce = sha256(nonce)
        
        
        
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


    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    

}

extension ViewController:LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: (any Error)?) {
        let idTokenString = AuthenticationToken.current?.tokenString
        let nonce = currentNonce
        let credential = OAuthProvider.credential(withProviderID: "facebook.com",
                                                  idToken: idTokenString!,
                                                  rawNonce: nonce)
        Auth.auth().signIn(with: credential)
                
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        do{
            try Auth.auth().signOut()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
}
