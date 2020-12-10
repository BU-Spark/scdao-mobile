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
    
    
    private var email: String = ""
    private var password: String = ""
    
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
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    private func validate() -> Bool {
        print("Email: " + email)
        print("Pass: " + password)
        
        if email.isEmpty || !isEmailValid(email)  {
            showInvalid(field: "Email", error: "Email is invalid")
            return false
        }
        
        
        if password.isEmpty {
            showInvalid(field: "Password", error: "Password is too short")
            return false
        }
        
        return true
    }
    
    private func showInvalid(field: String, error: String) {
        let alert = UIAlertController(title: field, message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showError(_ error: String) {
         
     }
    
    @IBAction
    private func onEmailTextChanged(_ textField: UITextField) {
        self.email = textField.text ?? ""
    }
    
        
    @IBAction
    private func onPasswordTextChanged(_ textField: UITextField) {
        self.password = textField.text ?? ""
    }
    
    @IBAction func loginPressed(_ button: UIButton) {
        
        // Check Text Fields
        
        
        // Still need to vaildate text fields [email,username]
        
        
        // Data Fields
        
        self.email = (emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.password = (passwordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check to see if login token exists --> segue to home vc if token exists
        guard validate() else { return }
        // Signing in User
        let apiCall = AuthAPI(baseURL: "localhost")
        
        apiCall.signin(user: email, pass: password) { [weak self] (isSuccess, error) in
            guard let this = self else { return }
            
            if isSuccess {
                // Go to Home Screen
                DispatchQueue.main.async {     //Do UI Code here.
                    let homeViewController = this.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? TabBarController

                    this.view.window?.rootViewController = homeViewController
                    this.view.window?.makeKeyAndVisible()
                    
                    
                }

            } else {
                this.errorLabel.text = error!.localizedDescription
                this.errorLabel.alpha = 1
            }
        }
    }
    
}
