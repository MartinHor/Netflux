//
//  LoginVC.swift
//  Netflux
//
//  Created by Martin Parker on 09/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import AuthenticationServices


class LoginVC: UIViewController, GIDSignInDelegate {
    
    //Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Change status bar text color to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // Unhashed nonce for Sign-in With Apple
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        loadAnimation()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    //Action
    @IBAction func googleSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    @IBAction func appleSignInPressed(_ sender: Any) {
        startSignInWithAppleFlow()
    }
    
    @IBAction func guestPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //Function for Google Sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        activityIndicator.startAnimating()
        
        guard let authentication  = user?.authentication else {
            self.activityIndicator.stopAnimating()
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        if error == nil {
            //Do what ever you want to do this
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil){
                    self.activityIndicator.stopAnimating()
                    self.simpleAlert(title: "Error", msg: "\(error?.localizedDescription ?? "")")
                    return
                }else{
                    //Dismiss and go to HomeVC
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }else{
            self.activityIndicator.stopAnimating()
            return
        }
    }
    
    //Function for Apple Sign in
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    func startSignInWithAppleFlow() {
        let nonce               = randomNonceString()
        currentNonce            = nonce
        let appleIDProvider     = ASAuthorizationAppleIDProvider()
        let request             = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce           = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    private func sha256(_ input: String) -> String {
        let inputData   = Data(input.utf8)
        let hashedData  = SHA256.hash(data: inputData)
        let hashString  = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

  
    
    func loadAnimation(){
        //Show from le right to left animation
        titleLabel.text     = ""
        var charIndex       = 0.0
        let titleText       = "🍿NETFLUX"
        
        for letter in titleText  {
            Timer.scheduledTimer(withTimeInterval: 0.10 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        //Show pulse animation
        let pulse               = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration          = 0.5
        pulse.fromValue         = 0.95
        pulse.toValue           = 1.0
        pulse.autoreverses      = true
        pulse.repeatCount       = 1
        pulse.initialVelocity   = 0.5
        pulse.damping           = 1.0
        titleLabel.layer.add(pulse, forKey: nil)
    }

}
extension LoginVC: ASAuthorizationControllerDelegate{
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        activityIndicator.startAnimating()
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    self.activityIndicator.stopAnimating()
                    self.simpleAlert(title: "Error", msg: "\(error?.localizedDescription ?? "")")
                    return
                }
                // User is signed in to Firebase with Apple.
                //Dismiss and go to HomeVC
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
        self.simpleAlert(title: "Sign in with Apple errored", msg: "\(error.localizedDescription)")
    }
    
}


extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}
