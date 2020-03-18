//
//  SearchController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/18/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import UIKit

class SearchController: UIViewController {

    var selectedName: String = "Anonymous"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @objc
    func handleDismiss() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DoUpdateLabel"), object: nil)
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
        navigationItem.title = "Search for a location"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24blue").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))

    }
}
