//
//  Login.swift
//  SCDAO-Mobile
//
//  Created by Jeffrey Jin on 7/11/21.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var userView: UIView!
    @IBOutlet private weak var passView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private var email: String = ""
    private var password: String = ""
    private var errorMessage: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "loginToSignup", sender: nil)
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    

    @IBAction func onEmailTextChanged(_ textField: UITextField) {
        self.email = textField.text ?? ""
    }

    @IBAction func onPasswordTextChanged(_ textField: UITextField) {
        self.password = textField.text ?? ""
    }
    
    private func validate() -> Bool {
        guard !self.email.isEmpty else {
            self.errorMessage = "Email field is empty"
            return false
        }
        guard !self.password.isEmpty else {
            self.errorMessage = "Password field is empty"
            return false
        }
        guard isEmailValid(self.email) else {
            self.errorMessage = "Please enter a valid email address"
            return false
        }
        return true
    }
    
    //check login credentials and create authentication token to login if successful
    @IBAction func loginPressed(_ button: UIButton) {
        // setup parameters and request URL
        let params: [String: Any] = ["username": self.email, "password": self.password]
        let loginRoute = Config.baseURL + "/api/token"
        
        if validate() {
            AF.request(loginRoute, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseJSON{
                    response in
                    do {
                        //
                        switch(response.result) {
                        case .failure(let error):
                            throw(error)
                        case .success(let JSON):
                            let res = JSON as! NSDictionary
                            let details = res.object(forKey: "detail")
                            if details == nil {
                                //handle login given successful sign in
                                let access_token = res.object(forKey: "access_token")!
                                let token_type = res.object(forKey: "token_type")!
                                let defaults = UserDefaults.standard
                                defaults.set(access_token, forKey: "tokenValue")
                                defaults.set(token_type, forKey: "tokenType")
                                
                                //change screen to main screen
                            } else {
                                self.errorLabel.text = "Incorrect username or password"
                            }
                        }
                    } catch {
                        self.errorLabel.text = "Connectivity issues or server may be down."
                    }
                }
        } else {
            errorLabel.text = self.errorMessage
        }
    }
}
