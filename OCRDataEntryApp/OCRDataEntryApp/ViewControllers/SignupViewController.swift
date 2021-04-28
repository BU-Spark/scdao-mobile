//
//  SignupViewController.swift
//  OCRDataEntryApp
//
//  Created by WAIL ATTAUABI on 10/30/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import UIKit

final class SignupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet
    private weak var contentView: UIView!
    @IBOutlet
    private weak var logoView: UIImageView!
    @IBOutlet
    private weak var emailField: UITextField!
    @IBOutlet
    private weak var usernameField: UITextField!
    @IBOutlet
    private weak var passwordField: UITextField!
    @IBOutlet
    private weak var confirmPasswordField: UITextField!
    @IBOutlet
    private weak var signupButton: UIButton!
    @IBOutlet
    private weak var signinButton: UIButton!
    
    private var email: String = ""
    private var username: String = ""
    private var password: String = ""
    private var confirmedPassword: String = ""
    private var originalBottomHeight: CGFloat = 0.0
    private var originalTopHeight: CGFloat = 0.0
    private var minPasswordLength: Int = 8
    private var userCreatedButtonPressed: Bool = false
    
    
    private func isPasswordValid(_ password : String) -> Bool{
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{" + String(minPasswordLength) + ",}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    //current assumption assumes password must be over minPassWordLength and include at least 1 number
    private func validate() -> Bool {
        //helps with debugging
//        print("Email: " + email)
//        print("Username: " + username)
//        print("Pass: " + password)
//        print("Confirm: " + confirmedPassword)
        
        //email is empty
        if email.isEmpty {
            showAlert(field: "Email", error: "Email is empty")
            return false
        }
        
        //email is not following email format, abc@xxx.zzz
        if !isEmailValid(email)  {
            showAlert(field: "Email", error: "Enter a valid email, make sure there is an email username followed by an '@' followed by a valid domain name")
            return false
        }
        
        //username field is empty
        if username.isEmpty {
            showAlert(field: "Username", error: "Username is empty")
            return false
        }
        
        //assuming password must be over minPassWordLength and include at least 1 number
        if !isPasswordValid(password) {
            if password.count < minPasswordLength{
                showAlert(field: "Password", error: "Password is too short, must be " + String(minPasswordLength) + " or more characters with at least one number")
            }
            // can edit the alert to display different messages depending on how password
            // requirements are set up
            else{
                showAlert(field: "Password", error: "Password is missing a number or character, must be " + String(minPasswordLength) + " or more characters with at least one number")
            }
            return false
        }
        
        //passwords dont match
        if confirmedPassword != password {
            showAlert(field: "Confirmed password", error: "Password does not match")
            return false
        }
        
        
        return true
    }
    
    //function that shows an alert, allows us to save code at various other points
    private func showAlert(field: String, error: String) {
        let alert = UIAlertController(title: field, message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet
    private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet
    private weak var topConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotifications(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.backgroundColor = .white
        //contentView.layer.cornerRadius = 20.0
        
        configureTextField(emailField, placeholder: "Email", image: "mail")
        configureTextField(usernameField, placeholder: "Username")
        configureTextField(passwordField, placeholder: "Password")
        configureTextField(confirmPasswordField, placeholder: "Confirm password")
        
        signupButton.layer.cornerRadius = 8.0
        signupButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        signupButton.layer.shadowColor = UIColor.gray.cgColor
        
        signinButton.layer.cornerRadius = 8.0
        signinButton.layer.borderColor = UIColor.darkGray.cgColor
        signinButton.layer.borderWidth = 1.0
        
        originalBottomHeight = bottomConstraint.constant
        originalTopHeight = topConstraint.constant
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String, image: String? = nil) {
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.placeholder = placeholder
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 20.0)
        textField.delegate = self
        
        let imageSize: CGFloat = 30.0
        let padding: CGFloat = 5.0
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        let iconView = UIImageView(frame: CGRect(x: padding, y: padding, width: imageSize - padding * 2, height: imageSize - padding * 2))
        
        leftView.addSubview(iconView)
        
        if let image = image {  
            iconView.image = UIImage(named: image)
            iconView.contentMode = .scaleAspectFit
        }

        textField.leftViewMode = .always
    }

    @IBAction
    private func onEmailTextChanged(_ textField: UITextField) {
        self.email = textField.text ?? ""
    }
    
    @IBAction
    private func onUsernameTextChanged(_ textField: UITextField) {
        self.username = textField.text ?? ""
    }
        
    @IBAction
    private func onPasswordTextChanged(_ textField: UITextField) {
        self.password = textField.text ?? ""
    }
    
    @IBAction
    private func onConfirmPasswordTextChanged(_ textField: UITextField) {
        self.confirmedPassword = textField.text ?? ""
    }

    @IBAction
    private func onLoginButtonTap(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction
    private func onSignupButtonTap(_ button: UIButton) {
        view.resignFirstResponder()
        
        self.email = (emailField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.username = (usernameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.password = (passwordField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.confirmedPassword = (confirmPasswordField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard validate() else { return }
        
       
        
        // Create User
        let apiCall = AuthAPI(baseURL: Config.baseURL)
        
        apiCall.signup(user: email, pass: password) { [weak self] (isSuccess, error, response)  in
            guard let this = self else { return }
            
            //if successful, display successful message and move to home screen
            if isSuccess {
                DispatchQueue.main.async{
                    let alert = UIAlertController(title: "Successful Signup", message: "Please login", preferredStyle: UIAlertController.Style.alert)


                    let loginAction = UIAlertAction(title: "Ok", style: .default){action in
              
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let homeViewController = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginViewController
                                    
                                    if homeViewController != nil {
                                        self?.view.window?.rootViewController = homeViewController
                                        self?.view.window?.makeKeyAndVisible()
                                    }
                            }

                        
                    alert.addAction(loginAction)

                    self?.present(alert, animated: true, completion: nil)
                }

            } else {
                //either backend is not running or the email already exists
                DispatchQueue.main.async {
                    //testing if backend is not running
                    if response == "Backend not running"{
                        this.showAlert(field: "Connection error", error: "Backend is not running")
                    }
                    else{
                        this.showAlert(field: "User already exists", error: "Enter a new email")
                    }
                    
                    
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension SignupViewController: KeyboardStateDelegate {
    func keyboardDidTransition(_ state: KeyboardState) {
        
    }
    
    func keyboardWillTransition(_ state: KeyboardState) {
        
    }
    
    func keyboardTransitionAnimation(_ state: KeyboardState) {
        switch state {
        case .activeWithHeight(let height):
            bottomConstraint.constant = height - signinButton.frame.height
            //topConstraint.constant = originalTopHeight - height
            logoView.alpha = 0.0
        
        case .hidden:
            bottomConstraint.constant = originalBottomHeight
            //topConstraint.constant = originalTopHeight
            logoView.alpha = 1.0
        }
        
        view.layoutSubviews()
    }
}
