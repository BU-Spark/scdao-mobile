//
//  LoginViewController.swift
//  OCRDataEntryApp
//
//  Created by Neilkaran Rawal on 11/2/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signup() {
        let singupController = SignupViewController()
        
        singupController.modalPresentationStyle = .fullScreen
        singupController.isModalInPresentation = true
        
        present(singupController, animated: true, completion: nil)
    }
    @IBAction func up() {
        let singupController = UploadViewController()
        
        singupController.modalPresentationStyle = .fullScreen
        singupController.isModalInPresentation = true
        
        present(singupController, animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        // Check Text Fields
        
        
        // Still need to vaildate text fields [email,username]
        
        
        // Data Fields
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check to see if login token exists --> segue to home vc if token exists
        
        // Signing in User
        let apiCall = AuthAPI(baseURL: "localhost")
        
        apiCall.signin(user: email, pass: password) { [weak self] (isSuccess, error) in
            guard let this = self else { return }
            
            if isSuccess {
                // Go to Home Screen
                let homeViewController = this.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                       
                this.view.window?.rootViewController = homeViewController
                this.view.window?.makeKeyAndVisible()
            } else {
                this.errorLabel.text = error!.localizedDescription
                this.errorLabel.alpha = 1
            }
        }
    }
    
}
