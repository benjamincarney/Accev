//
//  LoginViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

// import Firebase
// import FirebaseAuth
import UIKit

class LoginViewController: LoginRegisterViewController {
    // Text and Number Class Constants
    let linkSpacing: CGFloat = 10.0
    let logoSpacing: CGFloat = 20.0
    let maxLogoSizeMultiplier: CGFloat = 0.5
    let socialMediaButtonHeight: CGFloat = 80.0
    let socialMediaSpace: CGFloat = 20.0
    let sizeOfText: CGFloat = 15.0

    // UI Elements
    lazy var forgotPasswordLink: UIButton = {
        let link = TransitionLinkButton("Forgot Password?")
        link.translatesAutoresizingMaskIntoConstraints = false
        link.addTarget(self, action: #selector(forgotPasswordLinkTapped), for: .touchUpInside)
        return link
    }()

    lazy var registerLink: UIButton = {
        let link = TransitionLinkButton("Register")
        link.translatesAutoresizingMaskIntoConstraints = false
        link.addTarget(self, action: #selector(registerLinkTapped), for: .touchUpInside)
        return link
    }()

    // Overrides
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(forgotPasswordLink)
        contentView.addSubview(registerLink)
    }

    override func setUpConstraints() {
        super.setUpConstraints()

        let margins = contentView.layoutMarginsGuide

        loginRegisterButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor,
                                                 constant: loginButtonOffset).isActive = true
        loginRegisterButton.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        loginRegisterButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        forgotPasswordLink.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor,
                                                  constant: socialMediaSpace).isActive = true
        forgotPasswordLink.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        forgotPasswordLink.widthAnchor.constraint(equalTo: margins.widthAnchor,
                                                  constant: -(self.view.bounds.width / 3.0) - 10).isActive = true

        registerLink.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor,
                                                    constant: socialMediaSpace).isActive = true
        registerLink.widthAnchor.constraint(equalTo: margins.widthAnchor,
                                                      constant: -(self.view.bounds.width / 2) - 10).isActive = true
        registerLink.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true

    }

    override func getBottomSubview() -> UIView {
        return forgotPasswordLink
    }

    override func getSpaceAboveTitle() -> CGFloat {
        return 40.0
    }

    override func getSpaceBelowTitle() -> CGFloat {
        return 60.0
    }

    override func getTextFieldSeparation() -> CGFloat {
        return 12.0
    }

    func loginFailed() {
        let alertTitle = "Error"
        let alertText = "Login failed"
        let alertVC = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    // Event Listeners
    @objc
    func registerLinkTapped() {
        // routeTo(screen: .setupProfile)
    }

    @objc
    func forgotPasswordLinkTapped() {
        routeTo(screen: .forgotPassword)
    }

    // Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(
            buttonText: "Log In",
            screenTitle: "Accev", titleSize: 120) { (_ email: String, _ password: String) -> Void in
                // Ignored
        }
//        self.onButtonTap = { (_ email: String, _ password: String) in
//            Auth.auth().signIn(withEmail: email, password: password) { _ /* user */, _ /* error */ in
//                self.routeTo(screen: .camera)
//            }
//        }
    }
}
