//
//  ModalViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/14/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import UIKit

class ModalViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc
    func handleDismiss() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DoUpdateLabel"), object: nil)
        dismiss(animated: true, completion: nil)
    }
}
