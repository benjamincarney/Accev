//
//  FeedbackController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/15/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import UIKit

class FeedbackController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @objc
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    // UI Elements
    lazy var submitButton: UIButton = {
        let submitButton = UIButton(frame: CGRect(x: 0, y: 100, width: 200, height: 50))
        submitButton.setTitleColor(Colors.behindGradient, for: .normal)
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 3
        submitButton.layer.borderColor = UIColor(red: 16 / 255, green: 96 / 255, blue: 181 / 255, alpha: 1.0).cgColor
        submitButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        submitButton.setTitle("Submit Feedback", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        return submitButton
    }()

    @objc
    func submitButtonTapped(sender: UIButton!) {
        let alert = UIAlertController(title: "Feedback received", message: "Thanks for your feedback!",
                                      preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            self.handleDismiss()
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    func configureUI() {
        view.backgroundColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = Colors.behindGradient
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "Feedback"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24blue").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))

        self.view.addSubview(submitButton)


        submitButton.translatesAutoresizingMaskIntoConstraints = false

        submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75).isActive = true


    }
}
