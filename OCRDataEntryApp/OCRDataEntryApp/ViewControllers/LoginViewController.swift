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
    
    //tests if email is valid
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    //helper function to help validate login info
    private func validate() -> Bool {

        //helps with debugging
//        print("Email: " + email)
//        print("Pass: " + password)


        
        //email is empty
        if email.isEmpty {
            showInvalid(field: "Email", error: "Email is empty")
            return false
        }
        
        //email does not follow abc@xxx.zzz format
        if !isEmailValid(email)  {
            showInvalid(field: "Email", error: "Enter a valid email, make sure there is an email username followed by an '@' followed by a valid domain name")
            return false
        }
        
        //password field is empty
        if password.isEmpty {
            showInvalid(field: "Password", error: "Password is empty")
            return false
        }
        
        return true
    }
    
    //function that shows alerts, allows us to save code at various points
    private func showInvalid(field: String, error: String) {
        let alert = UIAlertController(title: field, message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction
    private func onEmailTextChanged(_ textField: UITextField) {
        self.email = textField.text ?? ""
    }
    
        
    @IBAction
    private func onPasswordTextChanged(_ textField: UITextField) {
        self.password = textField.text ?? ""
    }
    
    //check login credentials and create authentication token to login if successful
    @IBAction func loginPressed(_ button: UIButton) {
        
        self.email = "admin@scdao-api.org"//(emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.password = "password" //(passwordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)  
        
        // Check to see if login token exists --> segue to home vc if token exists
        guard validate() else { return }
        // Signing in User
        let apiCall = AuthAPI(baseURL: Config.baseURL)
        
        apiCall.signin(user: email, pass: password) { [weak self] (response, error, apiResponse) in
            guard let this = self else { return }
            
            if let error = error {
                //first check if backend is not running, otherwise the username or password
                //is incorrect
                DispatchQueue.main.async {
                    if apiResponse == "Backend not running"{
                        this.showInvalid(field: "Connection error", error: "Backend is not running")
                    }
                    else{
                        this.showInvalid(field: "Login Error", error: "Incorrect username or password")
                    }
                }
                return
            }
            
            guard let response = response else {
                DispatchQueue.main.async {
                    this.errorLabel.text = "Empty response"
                    this.errorLabel.alpha = 1
                }
                return
            }
            
            // Save user token
            UserDefaults.standard.setValue(response.token, forKey: "tokenValue")
            UserDefaults.standard.setValue(response.type, forKey: "tokenType")
            UserDefaults.standard.synchronize()
            
            // Go to Home Screen
            DispatchQueue.main.async {     //Do UI Code here.
                let homeViewController = this.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? TabBarController

                this.view.window?.rootViewController = homeViewController
                this.view.window?.makeKeyAndVisible()
                
                
            }
        }
    }
}
