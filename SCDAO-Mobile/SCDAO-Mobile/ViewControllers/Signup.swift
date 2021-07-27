//
//  Signup.swift
//  SCDAO-Mobile
//
//  Created by Jeffrey Jin on 7/11/21.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var email: String = ""
    private var user: String = ""
    private var password: String = ""
    private var passwordConf: String = ""
    private var minPasswordLength: Int = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view
        signupButton.layer.cornerRadius = 10

    }
    
    @IBAction func onEmailTextChanged(_ textField: UITextField) {
        self.email = textField.text ?? ""
    }
    @IBAction func onUserTextChanged(_ textField: UITextField) {
        self.user = textField.text ?? ""
    }
    @IBAction func onPasswordTextChanged(_ textField: UITextField) {
        self.password = textField.text ?? ""
    }
    @IBAction func onPasswordConfTextChanged(_ textField: UITextField) {
        self.passwordConf = textField.text ?? ""
    }
    
    private func isPasswordValid(_ password : String) -> Bool{
        // password has to be at least 8 characters and can only be alphanumeric
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{" + String(minPasswordLength) + ",}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    @IBAction func onSignupPressed(_ sender: UIButton) {

        let params: [String: Any] = ["username": self.email, "password": self.password]
        let signupRoute = Config.baseURL + "/api/signup"
        
        guard isPasswordValid(self.password) else {
            self.errorLabel.text = "Passwords can only contain alphanumeric characters"
            return
        }
        
        guard self.password.count >= 8 else {
            self.errorLabel.text = "Passwords have to be at least 8 characters long."
            return
        }
        
        guard self.password == self.passwordConf else {
            self.errorLabel.text = "Passwords do not match"
            return
        }
        
        AF.request(signupRoute, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseJSON {
                response in
                do {
                    print(response)
                    switch response.result {
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
                            self.errorLabel.text = details as? String
                        }
                    }
                } catch {
                    self.errorLabel.text = "Connectivity issues or server may be down."
                }
            }
        
    }
}
