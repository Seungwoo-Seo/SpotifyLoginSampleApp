//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 서승우 on 2023/02/22.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
        
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        resetPasswordButton.isHidden = !isEmailSignIn
    }
    
    
    @IBAction func didTapResetPasswordButton(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    @IBAction func didTapLogoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error: signout \(signOutError.localizedDescription)")
        }
        
    }
    
}
