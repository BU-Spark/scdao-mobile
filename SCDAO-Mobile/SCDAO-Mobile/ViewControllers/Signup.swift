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
    
    private var email: String = ""
    private var user: String = ""
    private var password: String = ""
    private var passwordConf: String = ""
    
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
    @IBAction func onSignupPressed(_ sender: UIButton) {

        let params: [String: Any] = ["username": self.email, "password": self.password]
        
        let signupRoute = Config.baseURL + "/api/signup"
        
        AF.request(signupRoute, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseJSON {
                response in
                do {
                    debugPrint(response)
                } catch {
                    
                }
            }
        
    }
}
