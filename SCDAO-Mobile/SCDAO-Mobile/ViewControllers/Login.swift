//
//  Login.swift
//  SCDAO-Mobile
//
//  Created by Jeffrey Jin on 7/11/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func signUpButton(_ sender: Any) {
//        let mainStoryBoard : UIStoryboard = UIStoryboard(name: "main", bundle: nil)
//        let signUpView = mainStoryBoard.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
//        self.present(signUpView, animated: true, completion: nil)
        performSegue(withIdentifier: "loginToSignup", sender: nil)
    }
}
