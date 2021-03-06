//
//  SetupProfileViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import FirebaseAuth
import UIKit

// Global Variables
var userFullName = ""
var userName = ""
var userProfileImage = UIImage()

class SetupProfileViewController: ScrollingViewController, UITextFieldDelegate {
    // Text and Number Class Constants
    let screenTitle = "Registration"
    let titleSize: CGFloat = 64.0
    let backgroundGradient = BackgroundGradient()
    let spaceAboveTitle: CGFloat = 40.0
    let spaceBelowTitle: CGFloat = 15.0
    let continueHeight: CGFloat = 67.0
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

    lazy var nameField: UITextField = {
        let field = UserEnterTextField("Full Name")
        field.delegate = self as UITextFieldDelegate
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .done
        field.autocapitalizationType = .words
        field.addTarget(self, action: #selector(fieldEdited), for: .editingChanged)
        return field
    }()

    lazy var usernameField: UITextField = {
        let field = UserEnterTextField("Username")
        field.delegate = self as UITextFieldDelegate
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .done
        field.autocapitalizationType = .words
        field.addTarget(self, action: #selector(fieldEdited), for: .editingChanged)
        return field
    }()

    lazy var continueButton: UIButton = {
        let button = LoginRegisterButton("Continue", height: continueHeight)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        return button
    }()

    lazy var hasAccountLink: UIButton = {
        let button = TransitionLinkButton("Have an account? Log in")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hasAccountTapped), for: .touchUpInside)
        return button
    }()

    // Custom Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func addSubviews() {
        contentView.addSubview(appTitle)
        contentView.addSubview(nameField)
        contentView.addSubview(usernameField)
        contentView.addSubview(continueButton)
        contentView.addSubview(hasAccountLink)
        backgroundGradient.addToView(view)
    }

    func setUpConstraints() {
        let margins = contentView.layoutMarginsGuide

        appTitle.widthAnchor.constraint(lessThanOrEqualTo: margins.widthAnchor).isActive = true
        appTitle.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        appTitle.topAnchor.constraint(equalTo: margins.topAnchor,
                                      constant: spaceAboveTitle).isActive = true

        nameField.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: buttonSpacing).isActive = true
        nameField.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        nameField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true

        usernameField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: buttonSpacing).isActive = true
        usernameField.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        usernameField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true

        continueButton.topAnchor.constraint(equalTo: usernameField.bottomAnchor,
                                        constant: buttonSpacing).isActive = true
        continueButton.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        continueButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true

        hasAccountLink.bottomAnchor.constraint(equalTo: margins.bottomAnchor,
                                               constant: -spacingFromBottom).isActive = true
        hasAccountLink.topAnchor.constraint(equalTo: continueButton.bottomAnchor,
                                            constant: buttonSpacing).isActive = true
        hasAccountLink.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        hasAccountLink.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
    }

    func isValidDisplayName(_ displayName: String) -> Bool {
        let regex = "(?i)^(?![- '])(?![×Þß÷þø])[- '0-9a-zÀ-ÿ]+(?<![- '])$"
        if displayName.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil &&
            displayName.count >= 5 &&
            displayName.count <= 20 {
            return true
        }
        return false
    }

    // Event Listeners
    @objc
    func fieldEdited() {
        continueButton.isEnabled = nameField.text != ""
    }

    @objc
    func hasAccountTapped() {
        routeTo(screen: .login)
    }

    @objc
    func continueTapped() {
        if isValidDisplayName(nameField.text ?? "") {
            print("continue tapped")
            userFullName = nameField.text ?? ""
            userName = usernameField.text ?? ""
            //userProfileImage = profilePicButton
            routeTo(screen: .register)
        } else {
            print("Not a valid display name")
            let alertTitle = "Invalid display name"
            let alertText = "Choose a display name betweeen 5 and 20 characters and that"
                + "contains only alphanumeric characters, spaces, hyphens, and apostrophes."
                + "Display name also cannot begin or end with a space, hyphen, or apostrophe"
            let alertVC = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @objc
    func changePicture() {
        print("Change picture")
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
