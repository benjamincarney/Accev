//
//  PinDetailsEntryController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/7/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import UIKit

class PinDetailsEntryController: UIViewController {

    var pinID: String?

    lazy var pinNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        constrainViews()

        if let pinID = pinID {
            print("Pinname is \(pinID)")
        } else {
            print("Pinname not found..")
        }
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
        navigationItem.title = "Enter Pin Details"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24blue").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))
        // Pin name
        view.addSubview(pinNameLabel)
    }

    func constrainViews() {
        // Pin name
        if #available(iOS 11.0, *) {
            pinNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            pinNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        pinNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true

    }
}
