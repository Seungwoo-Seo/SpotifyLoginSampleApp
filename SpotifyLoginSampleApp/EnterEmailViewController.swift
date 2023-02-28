//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 서승우 on 2023/02/22.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {return}
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 때
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                self.showMainViewController()
            }
        }
    }
    
    private func showMainViewController() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.show(vc, sender: nil)
    }
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else {return}
            
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
    }
    
    private func attribute() {
        nextButton.alpha = 0.5
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false
        
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        
        passwordTextField.delegate = self
    }
    
}

extension EnterEmailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        
        if !isEmailEmpty && !isPasswordEmpty {
            nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
        
    }
}
