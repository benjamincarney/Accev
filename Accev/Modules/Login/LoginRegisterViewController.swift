//
//  LoginRegisterViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Firebase
import UIKit

class LoginRegisterViewController: RoutedViewController, UITextFieldDelegate {
    // Text and Number Class Constants
    let titleSize: CGFloat
    let loginButtonOffset: CGFloat = 33.0
    let loginButtonHeight: CGFloat = 67.0
    let buttonText: String
    var onButtonTap: (_ email: String, _ password: String) -> Void
    let screenTitle: String

    // UI Elements
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var appTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = screenTitle
        label.textAlignment = .center
        label.textColor = Colors.text
        label.font = R.font.latoRegular(size: titleSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var emailField: UITextField = {
        let field = LoginTextField("email", isSecure: false, isEmail: true)
        field.delegate = self as UITextFieldDelegate
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(fieldEdited), for: .editingChanged)
        return field
    }()
    lazy var passwordField: UITextField = {
        let field = LoginTextField("password", isSecure: true, isEmail: false)
        field.delegate = self as UITextFieldDelegate
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(fieldEdited), for: .editingChanged)
        return field
    }()

    lazy var loginRegisterButton: UIButton = {
        let button = LoginRegisterButton(buttonText, height: loginButtonHeight)
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginRegisterButtonTapped), for: .touchUpInside)
        return button
    }()

    let backgroundGradient = BackgroundGradient()

    // Custom Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func shouldEnableSignIn() -> Bool {
        return emailField.text != "" && passwordField.text != ""
    }

    func getBottomSubview() -> UIView {
        return passwordField
    }

    func getSpaceAboveTitle() -> CGFloat {
        return 40.0
    }

    func getSpaceBelowTitle() -> CGFloat {
        return 50.0
    }

    func getTextFieldSeparation() -> CGFloat {
        return 12.0
    }

    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(appTitle)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(loginRegisterButton)
        backgroundGradient.addToView(view)
    }

    func setUpConstraints() {
        let parentMargins = view.layoutMarginsGuide
        let margins = contentView.layoutMarginsGuide

        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: parentMargins.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: parentMargins.widthAnchor).isActive = true

        appTitle.widthAnchor.constraint(lessThanOrEqualTo: margins.widthAnchor).isActive = true
        appTitle.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        appTitle.topAnchor.constraint(equalTo: margins.topAnchor,
                                      constant: getSpaceAboveTitle()).isActive = true

        emailField.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        emailField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        emailField.topAnchor.constraint(equalTo: appTitle.bottomAnchor,
                                        constant: getTextFieldSeparation()).isActive = true

        passwordField.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor,
                                           constant: getTextFieldSeparation()).isActive = true
        passwordField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true

        getBottomSubview().bottomAnchor.constraint(equalTo: margins.bottomAnchor,
                                                   constant: getTextFieldSeparation()).isActive = true
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

    // Event Handlers
    @objc
    func loginRegisterButtonTapped() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { _ /* user */, error in
           if error == nil {
                print("Signed In Successfully!")
                self.onButtonTap(email, password)
                return
            }
            let alertTitle = "Error"
            let alertText = "Login failed"
            let alertVC = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @objc
    func fieldEdited() {
        loginRegisterButton.isEnabled = shouldEnableSignIn()
    }

    // Initializers
    required init?(coder aDecoder: NSCoder) {
        self.buttonText = "Button"
        self.onButtonTap = { _, _ in }
        self.screenTitle = "Title"
        self.titleSize = 100
        super.init(coder: aDecoder)
    }
    init(buttonText: String,
         screenTitle: String,
         titleSize: CGFloat,
         onButtonTap: @escaping (_ email: String, _ password: String) -> Void) {
        self.buttonText = buttonText
        self.onButtonTap = onButtonTap
        self.screenTitle = screenTitle
        self.titleSize = titleSize
        super.init(nibName: nil, bundle: nil)
    }
}
