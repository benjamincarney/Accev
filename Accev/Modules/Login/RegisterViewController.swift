//
//  RegisterViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

 import Firebase
 import FirebaseAuth
import UIKit

class RegisterViewController: LoginRegisterViewController {
    // Text and Number Class Constants
    let linkSpacing: CGFloat = 10.0
    let socialMediaButtonHeight: CGFloat = 50.0
    let socialMediaSpace: CGFloat = 20.0
    let sizeOfText: CGFloat = 27.0

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

    // Event Listeners
    @objc
    func haveAnAccountTapped() {
        print("have an account")
        routeTo(screen: .login)
    }

    // Custom Functions
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

    }

    override func shouldEnableSignIn() -> Bool {

        return super.shouldEnableSignIn() && confirmPasswordField.text != "" &&
               confirmPasswordField.text == passwordField.text
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
                print("registered user")
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.failedRegistration()
                    return
                }
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
