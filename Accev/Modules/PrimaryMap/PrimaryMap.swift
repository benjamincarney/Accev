//
//  PrimaryMap.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class PrimaryMapViewController: RoutedViewController {

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
        label.text = "Map"
        label.textAlignment = .center
        label.textColor = Colors.text
        label.font = R.font.latoRegular(size: 90)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let backgroundGradient = BackgroundGradient()

    // Custom Functions
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
        
    }

    // Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init() {

        super.init(nibName: nil, bundle: nil)
    }

}
