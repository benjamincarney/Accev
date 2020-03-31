//
//  ProfileController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/18/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import FirebaseAuth
import UIKit

class ProfileController: RoutedViewController {

    var email: String?
    var numPinsMade: Int?
    var numUpvotes: Int?
    var numDownvotes: Int?

    let backendCaller = BackendCaller()

    lazy var loginLabel: UILabel = {
        let login = UILabel()
        login.text = "Please login to view your profile."
        login.textColor = .gray
        login.font = R.font.latoRegular(size: 24)
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()

    lazy var emailLabel: UILabel = {
        let eLab = UILabel()
        eLab.text = "Email: \(String(describing: self.email ?? ""))"
        eLab.font = R.font.latoRegular(size: 25)
        eLab.translatesAutoresizingMaskIntoConstraints = false
        return eLab
    }()

    lazy var numPinsLabel: UILabel = {
        let pinLab = UILabel()
        pinLab.text = "Pins placed: \(String(describing: self.numPinsMade ?? -1))"
        pinLab.font = R.font.latoRegular(size: 25)
        pinLab.translatesAutoresizingMaskIntoConstraints = false
        return pinLab
    }()

    lazy var numUpvotesLabel: UILabel = {
        let upLab = UILabel()
        upLab.text = "Upvotes given: \(String(describing: self.numUpvotes ?? -1))"
        upLab.font = R.font.latoRegular(size: 25)
        upLab.translatesAutoresizingMaskIntoConstraints = false
        return upLab
    }()

    lazy var numDownvotesLabel: UILabel = {
        let downLab = UILabel()
        downLab.text = "Downvotes given: \(String(describing: self.numDownvotes ?? -1))"
        downLab.font = R.font.latoRegular(size: 25)
        downLab.translatesAutoresizingMaskIntoConstraints = false
        return downLab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Should only display info if the user is logged in
        if Auth.auth().currentUser != nil {
            // Save profile info
            self.email = Auth.auth().currentUser?.email
            backendCaller.fetchProfileInfo(email: self.email ?? "") { userData in
                if userData != nil {
                    self.numUpvotes = userData?["numUpvotesGiven"] as? Int
                    self.numDownvotes = userData?["numDownvotesGiven"] as? Int
                    self.numPinsMade = userData?["numPinsAdded"] as? Int
                } else {
                    print("Error fetching user data")
                }
                // Display profile info
                self.configureContent()
            }
        } else {
            displayLoginButton()
        }
    }

    func configureContent() {
        // Add subviews
        view.addSubview(emailLabel)
        view.addSubview(numPinsLabel)
        view.addSubview(numUpvotesLabel)
        view.addSubview(numDownvotesLabel)

        // Constrain subviews
        if #available(iOS 11.0, *) {
            emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            // Fallback on earlier versions
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        }
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true

        numPinsLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20).isActive = true
        numPinsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        numPinsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true

        numUpvotesLabel.topAnchor.constraint(equalTo: numPinsLabel.bottomAnchor, constant: 20).isActive = true
        numUpvotesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        numUpvotesLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true

        numDownvotesLabel.topAnchor.constraint(equalTo: numUpvotesLabel.bottomAnchor, constant: 20).isActive = true
        numDownvotesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        numDownvotesLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }

    func displayLoginButton() {
        view.addSubview(loginLabel)

        if #available(iOS 11.0, *) {
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            // Fallback on earlier versions
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        }

        loginLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }

    @objc
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    func configureUI() {
        view.backgroundColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = Colors.behindGradient
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "Profile"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24blue").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))
    }
}
