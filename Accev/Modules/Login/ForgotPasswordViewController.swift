//
//  ForgotPasswordViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import FirebaseAuth
import UIKit

class ForgotPasswordViewController: ScrollingViewController, UITextFieldDelegate {
    // Text and Number Class Constants
    let screenTitle = "Reset Password"
    let titleSize: CGFloat = 80.0
    let backgroundGradient = BackgroundGradient()
    let spaceAboveTitle: CGFloat = 40.0
    let spaceBelowTitle: CGFloat = 15.0
    let resetPasswordHeight: CGFloat = 67.0
    let buttonSpacing: CGFloat = 35.0
    let spacingFromBottom: CGFloat = 10

    // UI Elements
    lazy var appTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = screenTitle
        label.textAlignment = .center
        label.textColor = Colors.text
        label.font = R.font.latoRegular(size: titleSize)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var emailField: UITextField = {
        let field = UserEnterTextField("Email")
        field.delegate = self as UITextFieldDelegate
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(fieldEdited), for: .editingChanged)
        return field
    }()

    lazy var resetPasswordButton: UIButton = {
        let button = LoginRegisterButton("Reset Password", height: resetPasswordHeight)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetPasswordTapped), for: .touchUpInside)
        return button
    }()

    lazy var hasAccountLink: UIButton = {
        let button = TransitionLinkButton("Have an account? Log in")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hasAccountTapped), for: .touchUpInside)
        return button
    }()

    lazy var noAccountLink: UIButton = {
        let button = TransitionLinkButton("No account? Register")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(noAccountTapped), for: .touchUpInside)
        return button
    }()

    // Custom Functions
    func addSubviews() {
        contentView.addSubview(appTitle)
        contentView.addSubview(emailField)
        contentView.addSubview(resetPasswordButton)
        contentView.addSubview(hasAccountLink)
        contentView.addSubview(noAccountLink)
        backgroundGradient.addToView(view)
    }

    func setUpConstraints() {
        let margins = contentView.layoutMarginsGuide

        appTitle.widthAnchor.constraint(lessThanOrEqualTo: margins.widthAnchor).isActive = true
        appTitle.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        appTitle.topAnchor.constraint(equalTo: margins.topAnchor,
                                      constant: spaceAboveTitle).isActive = true
        appTitle.bottomAnchor.constraint(lessThanOrEqualTo: emailField.topAnchor,
                                         constant: -spaceBelowTitle).isActive = true

        emailField.bottomAnchor.constraint(equalTo: resetPasswordButton.topAnchor,
                                           constant: -buttonSpacing).isActive = true
        emailField.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        emailField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true

        resetPasswordButton.bottomAnchor.constraint(equalTo: hasAccountLink.topAnchor,
                                                    constant: -buttonSpacing).isActive = true
        resetPasswordButton.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        resetPasswordButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true

        hasAccountLink.bottomAnchor.constraint(equalTo: noAccountLink.topAnchor,
                                            constant: -buttonSpacing).isActive = true
        hasAccountLink.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        hasAccountLink.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true

        noAccountLink.bottomAnchor.constraint(equalTo: margins.bottomAnchor,
                                              constant: -spacingFromBottom).isActive = true
        noAccountLink.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        noAccountLink.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

    // Event Listeners
    @objc
    func fieldEdited() {
        resetPasswordButton.isEnabled = emailField.text != ""
    }

    @objc
    func hasAccountTapped() {
        routeTo(screen: .login)
    }

    @objc
    func noAccountTapped() {
        routeTo(screen: .setupProfile)
    }

    @objc
    func resetPasswordTapped() {
        let email = emailField.text ?? ""

        if isValid(email) {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                var alertText = "An email with instructions for resetting your " +
                    "password has been sent to " + email + "."
                var alertTitle = "Success"
                if let theError = error {
                    alertTitle = "Error"
                    print("Error with password reset: \(theError.localizedDescription)")
                    alertText = "An error occurred while resetting your password."
                }
                let alertVC = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        } else {
            print("Invalid Email")

            // Show invalid email notification
            let alertVC = UIAlertController(title: "Error", message: "Invalid Email", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }

    }

    // Overrides
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpConstraints()
        backgroundGradient.layoutInView(view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }
}
