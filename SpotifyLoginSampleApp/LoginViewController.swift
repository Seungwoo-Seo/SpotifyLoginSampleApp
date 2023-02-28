//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 서승우 on 2023/02/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func didTapGoogleLoginButton(_ sender: UIButton) {
        // Start the sign in flow!
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {return}
            guard let signInResult = signInResult else {return}
            
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else {return}
                guard let user = user else {return}
                
                let idToken = user.idToken?.tokenString ?? ""
                let accessToken = user.accessToken.tokenString
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    guard error == nil else {return}
                
                    self?.showMainViewController()
                }
            }
        }
    }
    
    @IBAction func didTapAppleLoginButton(_ sender: UIButton) {
        
    }
    
    private func showMainViewController() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: nil)
    }
    
    private func attribute() {
        navigationController?.navigationBar.tintColor = .white
        
        [
            emailLoginButton,
            googleLoginButton,
            appleLoginButton
        ].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
}
