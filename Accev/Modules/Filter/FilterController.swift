//
//  FilterController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/7/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import UIKit

class FilterController: UIViewController {

    var pinID: String?
    var homeViewController: HomeController?
    var accessibleWheelchairSwitched: Bool
    var accessibleBrailleSwitched: Bool
    var accessibleHearingSwitched: Bool

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

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
    
    // UI Elements
    lazy var submitButton: UIButton = {
        let submitButton = UIButton(frame: CGRect(x: 0, y: 100, width: 150, height: 50))
        submitButton.setTitleColor(Colors.behindGradient, for: .normal)
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 3
        submitButton.layer.borderColor = UIColor(red: 16/255, green: 96/255, blue: 181/255, alpha: 1.0).cgColor
        submitButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        submitButton.setTitle("Apply filters", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        return submitButton
    }()
    
    lazy var wheelchairButton: UISwitch = {
        let switchOnOff = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        switchOnOff.addTarget(self, action: #selector(wheelchairButtonSwitched), for: .valueChanged)
        switchOnOff.setOn(true, animated: false)
        return switchOnOff
    }()
    
    lazy var hearingButton: UISwitch = {
        let switchOnOff = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        switchOnOff.addTarget(self, action: #selector(hearingButtonSwitched), for: .valueChanged)
        switchOnOff.setOn(true, animated: false)
        return switchOnOff
    }()
    
    lazy var brailleButton: UISwitch = {
        let switchOnOff = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        switchOnOff.addTarget(self, action: #selector(brailleButtonSwitched), for: .valueChanged)
        switchOnOff.setOn(true, animated: false)
        return switchOnOff
    }()
    
    @objc
    func submitButtonTapped(sender: UIButton!) {
      print("Button tapped")
    }
    
    @objc
    func wheelchairButtonSwitched(sender: UISwitch!) {
        self.accessibleWheelchairSwitched = !self.accessibleWheelchairSwitched
    }
    
    @objc
    func hearingButtonSwitched(sender: UISwitch!) {
        self.accessibleHearingSwitched = !self.accessibleHearingSwitched
    }
    
    @objc
    func brailleButtonSwitched(sender: UISwitch!) {
        self.accessibleBrailleSwitched = !self.accessibleBrailleSwitched
    }


    func configureUI() {
        
        view.backgroundColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = Colors.behindGradient
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "Filter"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24blue").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))
        
        self.view.addSubview(submitButton)
        self.view.addSubview(wheelchairButton)
        self.view.addSubview(hearingButton)
        self.view.addSubview(brailleButton)
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        wheelchairButton.translatesAutoresizingMaskIntoConstraints = false
        hearingButton.translatesAutoresizingMaskIntoConstraints = false
        brailleButton.translatesAutoresizingMaskIntoConstraints = false
        
        submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        
    }
    
   // Initializers
    required init?(coder aDecoder: NSCoder) {
        self.accessibleWheelchairSwitched = true
        self.accessibleBrailleSwitched = true
        self.accessibleHearingSwitched = true
        super.init(coder: aDecoder)
    }
    init() {
        self.accessibleWheelchairSwitched = true
        self.accessibleBrailleSwitched = true
        self.accessibleHearingSwitched = true
        super.init(nibName: nil, bundle: nil)
    }
}
