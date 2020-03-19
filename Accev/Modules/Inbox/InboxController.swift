//
//  InboxController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/18/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class InboxController: UIViewController {

    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

    }

    @objc
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    lazy var descriptionLabel: UITextView = {
        let wheelchairLabel = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        wheelchairLabel.text = """
                        Under Construction!
                        """
        wheelchairLabel.textColor = .gray
        wheelchairLabel.font = R.font.latoRegular(size: 16)
        wheelchairLabel.contentOffset = .zero
        return wheelchairLabel
    }()

    func configureUI() {
        view.backgroundColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = Colors.behindGradient
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "Inbox"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24blue").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))

        self.view.addSubview(descriptionLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let screenSize = UIScreen.main.bounds

        descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: screenSize.width - 20).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: screenSize.height - 150).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
    }
}
