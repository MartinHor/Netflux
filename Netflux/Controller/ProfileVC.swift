//
//  ProfileVC.swift
//  Netflux
//
//  Created by Martin Parker on 09/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileVC: UIViewController {
    
    //Outlet
    @IBOutlet weak var loginOutBtn: LoginRoundedButton!
    @IBOutlet weak var displayNameLbl: UILabel!
    
    //Set the status bar text color to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        configureNavBar()
        updateUI()
    }
    
    @IBAction func loginOutBtnPressed(_ sender: Any) {
        if let _ = Auth.auth().currentUser {
            // We are logged in, try to sign out user
            do{
                try Auth.auth().signOut()
                if let tab = tabBarController  {
                    tab.selectedIndex = 0
                    if let navcon = tab.selectedViewController as? UINavigationController {
                        navcon.popToRootViewController(animated: true)
                    }
                }
                self.presentLoginController()
                print("Logout success")
            }catch{
                print(error.localizedDescription)
            }
            
        }else{
            //We are not logged in, push loginVC to user
            //Go back to the first tab bar cuz we are located at the last tab bar
            if let tab = tabBarController  {
                tab.selectedIndex = 0
                if let navcon = tab.selectedViewController as? UINavigationController {
                    navcon.popToRootViewController(animated: true)
                }
            }
            self.presentLoginController()
        }
    }
    
    // Present LoginStorboard
    func presentLoginController(){
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard , bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
        present(controller, animated: false, completion: nil)
        
    }
    //Hide the navigation bar
    func configureNavBar(){
        navigationController?.isNavigationBarHidden = true
    }
    
    //Update UI element
    func updateUI(){
        if Auth.auth().currentUser != nil {
            //We are logged in
            DispatchQueue.main.async {
                self.displayNameLbl.text = Auth.auth().currentUser?.displayName ?? "Apple ID: \n\(Auth.auth().currentUser?.email ?? "Apple ID is hidden")"
                self.loginOutBtn.setTitle("Sign Out", for: .normal)
            }
        }else{
            //Guest
            DispatchQueue.main.async {
                self.displayNameLbl.text = "Guest"
                self.loginOutBtn.setTitle("Login", for: .normal)
            }
        }
    }
    
    
    
}
