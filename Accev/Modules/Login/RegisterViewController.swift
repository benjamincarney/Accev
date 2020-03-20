//
//  RegisterViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import UIKit

class RegisterViewController: LoginRegisterViewController, GIDSignInDelegate {
    // Text and Number Class Constants
    let linkSpacing: CGFloat = 10.0
    let socialMediaButtonHeight: CGFloat = 50.0
    let socialMediaSpace: CGFloat = 20.0
    let sizeOfText: CGFloat = 27.0
    
    // let backend = BackendCaller()
    
    // UI Elements
    lazy var confirmPasswordField: UITextField = {
        let field = LoginTextField("confirm password", isSecure: true, isEmail: false)
        field.delegate = self as UITextFieldDelegate
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(fieldEdited), for: .editingChanged)
        return field
    }()
    
    lazy var haveAnAccountLink: UIButton = {
        let button = TransitionLinkButton("Have an account?")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(haveAnAccountTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var googleRegisterButton: UIButton = {
        var button: UIButton
        if let image = R.image.googleLogo() {
            button = SocialMediaLoginButton("register with google",
                                            height: socialMediaButtonHeight, textSize: sizeOfText, image: image)
        } else {
            button = UIButton()
            button.setTitle("register with google", for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(googleRegisterTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var facebookRegisterButton: UIButton = {
        var button: UIButton
        if let image = R.image.facebookLogo() {
            button = SocialMediaLoginButton("register with facebook",
                                            height: socialMediaButtonHeight, textSize: sizeOfText, image: image)
        } else {
            button = UIButton()
            button.setTitle("register with facebook", for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(facebookRegisterTapped), for: .touchUpInside)
        return button
    }()
    
    // Event Listeners
    @objc
    func facebookRegisterTapped() {
        print("Attempted Facebook registration")
        let loginManager = LoginManager()
        if let currentAccessToken = AccessToken.current, currentAccessToken.appID != Settings.appID {
            loginManager.logOut()
        }
        // Depreciated logIn method (should create an issue on github)
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .success(granted: _, declined: _, token: _):
                self.facebookSignIn()
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User Cancelled Login")
            }
        }
    }
    
    func facebookSignIn() {
        guard let accessToken = AccessToken.current?.tokenString else {
            print("Access Token Missing")
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { user, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print(user, " successfully logged in into Facebook")
            self.routeTo(screen: .primaryMap)
        }
    }
    
    @objc
    func haveAnAccountTapped() {
        routeTo(screen: .login)
    }
    
    // Custom Functions
    // Handle errors
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing in \(error)")
        }
    }
    
    func failedRegistration() {
        let alertTitle = "Error"
        let alertText = "Registration failed"
        let alertVC = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // Overrides
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(confirmPasswordField)
        contentView.addSubview(haveAnAccountLink)
        contentView.addSubview(googleRegisterButton)
        contentView.addSubview(facebookRegisterButton)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        let margins = contentView.layoutMarginsGuide
        
        confirmPasswordField.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor,
                                                  constant: getTextFieldSeparation()).isActive = true
        confirmPasswordField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        loginRegisterButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor,
                                                 constant: loginButtonOffset).isActive = true
        loginRegisterButton.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        loginRegisterButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        haveAnAccountLink.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor,
                                               constant: linkSpacing).isActive = true
        haveAnAccountLink.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        googleRegisterButton.topAnchor.constraint(equalTo: haveAnAccountLink.bottomAnchor,
                                                  constant: socialMediaSpace).isActive = true
        googleRegisterButton.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        googleRegisterButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        facebookRegisterButton.topAnchor.constraint(equalTo: googleRegisterButton.bottomAnchor,
                                                    constant: socialMediaSpace).isActive = true
        facebookRegisterButton.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        facebookRegisterButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
    }
    
    override func shouldEnableSignIn() -> Bool {
        return super.shouldEnableSignIn() && confirmPasswordField.text != "" &&
            confirmPasswordField.text == passwordField.text
    }
    
    override func getBottomSubview() -> UIView {
        return facebookRegisterButton
    }
    
    // Checks if input String is a valid email
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @objc
    func googleRegisterTapped() {
        print("Attempted Google registration")
        // Register with Google
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        routeTo(screen: .primaryMap)
        //GIDSignIn.sharedInstance().signInSilently()
    }
    
    // Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(buttonText: "sign up",
                   screenTitle: "Registration", titleSize: 64) { (_ email: String, _ password: String) -> Void in
                    print("Attempted registration with email \(email) and password \(password)")
        }
    }
    
    @objc
    func user_Registration() {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password) { _ /*authResult*/, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.failedRegistration()
                    return
                }
                // TODO: Update user with profile picture
                print("Account Created!")
                self.routeTo(screen: .primaryMap)
            }
        }
    }
    
    override func loginRegisterButtonTapped() {
        let password = passwordField.text ?? ""
        let confirmPassword = confirmPasswordField.text ?? ""
        if isValid(emailField.text ?? "") && password.count >= 8 && password == confirmPassword {
            user_Registration()
        } else {
            let alertTitle = "Error"
            let alertText = "Email must be valid, password must be at least 8 characters, " +
            "and password and confirm password must be the same."
            let alertVC = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
