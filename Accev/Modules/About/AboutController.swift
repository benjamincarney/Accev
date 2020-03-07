//
//  AboutController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/6/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        if let username = username {
            print("Username is \(username)")
        } else {
            print("Username not found..")
        }
    }

    @objc
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    func configureUI() {
        view.backgroundColor = Colors.behindGradient
        navigationController?.navigationBar.barTintColor = Colors.behindGradient
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "About"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_clear_white_36pt_3x").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))
    }
}
