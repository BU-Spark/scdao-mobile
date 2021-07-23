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
    
    private var minPasswordLength: Int = 8
    private var email: String = ""
    private var password: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "loginToSignup", sender: nil)
    }
    
    private func isPasswordValid(_ password : String) -> Bool{
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{" + String(minPasswordLength) + ",}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
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
//        guard isEmailValid(this.email)
        return true
    }
    
    //check login credentials and create authentication token to login if successful
    @IBAction func loginPressed(_ button: UIButton) {
        // setup parameters and request URL
        let params: [String: Any] = ["username": self.email, "password": self.password]
        let loginRoute = Config.baseURL + "/api/token"
        
        print(params)
        
        AF.request(loginRoute, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseJSON{
                response in
                do {
                    //
                    debugPrint(response)
                } catch {
                    
                }
                    
            }
        
    }
}
