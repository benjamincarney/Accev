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
    var accessibleWheelchair: Bool
    var accessibleBraille: Bool
    var accessibleHearing: Bool

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
        submitButton.layer.borderColor = UIColor(red: 16 / 255, green: 96 / 255, blue: 181 / 255, alpha: 1.0).cgColor
        submitButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        submitButton.setTitle("Apply filters", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        return submitButton
    }()

    lazy var wheelchairButton: UISwitch = {
        let switchOnOff = UISwitch(frame: CGRect(x: 150, y: 150, width: 0, height: 0))
        switchOnOff.isOn = true
        switchOnOff.setOn(true, animated: false)
        switchOnOff.addTarget(self, action: #selector(wheelchairButtonSwitched), for: .valueChanged)
        switchOnOff.backgroundColor = Colors.behindGradient
        switchOnOff.layer.cornerRadius = switchOnOff.bounds.height / 2
        switchOnOff.tintColor = .gray
        return switchOnOff
    }()

    lazy var hearingButton: UISwitch = {
        let switchOnOff = UISwitch(frame: CGRect(x: 150, y: 150, width: 0, height: 0))
        switchOnOff.addTarget(self, action: #selector(hearingButtonSwitched), for: .touchUpInside)
        switchOnOff.setOn(false, animated: false)
        switchOnOff.backgroundColor = Colors.behindGradient
        switchOnOff.layer.cornerRadius = switchOnOff.bounds.height / 2
        return switchOnOff
    }()

    lazy var brailleButton: UISwitch = {
        let switchOnOff = UISwitch(frame: CGRect(x: 150, y: 150, width: 0, height: 0))
        switchOnOff.addTarget(self, action: #selector(brailleButtonSwitched), for: .touchUpInside)
        switchOnOff.setOn(false, animated: false)
        switchOnOff.backgroundColor = Colors.behindGradient
        switchOnOff.layer.cornerRadius = switchOnOff.bounds.height / 2
        return switchOnOff
    }()

    lazy var wheelchairLabel: UILabel = {
        let wheelchairLabel = UILabel(frame: CGRect(x: 150, y: 150, width: 0, height: 0))
        wheelchairLabel.text = "Wheelchair Accessible"
        wheelchairLabel.textColor = Colors.behindGradient
        wheelchairLabel.font = R.font.latoRegular(size: 25)
        return wheelchairLabel
    }()

    lazy var hearingLabel: UILabel = {
        let hearingLabel = UILabel(frame: CGRect(x: 150, y: 150, width: 0, height: 0))
        hearingLabel.text = "Hearing Accessible"
        hearingLabel.textColor = Colors.behindGradient
        hearingLabel.font = R.font.latoRegular(size: 25)
        return hearingLabel
    }()

    lazy var brailleLabel: UILabel = {
        let brailleLabel = UILabel(frame: CGRect(x: 150, y: 150, width: 0, height: 0))
        brailleLabel.text = "Braille Accessible"
        brailleLabel.textColor = Colors.behindGradient
        brailleLabel.font = R.font.latoRegular(size: 25)
        return brailleLabel
    }()

    @objc
    func submitButtonTapped(sender: UIButton!) {
      print("Button tapped")
    }
    
    @objc
    func wheelchairButtonSwitched(_ sender: UISwitch!) {
        print(sender.isOn)
        if sender.isOn {
            print("is on")
            self.accessibleWheelchair = !self.accessibleWheelchair
        } else {
            print("is off")
            self.accessibleWheelchair = !self.accessibleWheelchair
        }
    }

    @objc
    func hearingButtonSwitched(_ sender: UISwitch!) {

    }

    @objc
    func brailleButtonSwitched(_ sender: UISwitch!) {

    }

    func configureUI() {

        view.backgroundColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = .gray
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
        self.view.addSubview(wheelchairLabel)
        self.view.addSubview(hearingLabel)
        self.view.addSubview(brailleLabel)
        self.view.addSubview(wheelchairButton)
        self.view.addSubview(hearingButton)
        self.view.addSubview(brailleButton)

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        wheelchairLabel.translatesAutoresizingMaskIntoConstraints = false
        hearingLabel.translatesAutoresizingMaskIntoConstraints = false
        brailleLabel.translatesAutoresizingMaskIntoConstraints = false
        wheelchairButton.translatesAutoresizingMaskIntoConstraints = false
        hearingButton.translatesAutoresizingMaskIntoConstraints = false
        brailleButton.translatesAutoresizingMaskIntoConstraints = false

        submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75).isActive = true

        wheelchairLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        wheelchairLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true

        brailleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        brailleLabel.topAnchor.constraint(equalTo: wheelchairLabel.bottomAnchor, constant: 40).isActive = true

        hearingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        hearingLabel.topAnchor.constraint(equalTo: brailleLabel.bottomAnchor, constant: 40).isActive = true

        wheelchairButton.leftAnchor.constraint(equalTo: wheelchairLabel.rightAnchor, constant: 20).isActive = true
        wheelchairButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true

        brailleButton.leftAnchor.constraint(equalTo: brailleLabel.rightAnchor, constant: 20).isActive = true
        brailleButton.topAnchor.constraint(equalTo: wheelchairLabel.bottomAnchor, constant: 40).isActive = true

        hearingButton.leftAnchor.constraint(equalTo: hearingLabel.rightAnchor, constant: 20).isActive = true
        hearingButton.topAnchor.constraint(equalTo: brailleLabel.bottomAnchor, constant: 40).isActive = true

    }

   // Initializers
    required init?(coder aDecoder: NSCoder) {
        self.accessibleWheelchair = true
        self.accessibleBraille = true
        self.accessibleHearing = true
        super.init(coder: aDecoder)
    }
    init() {
        self.accessibleWheelchair = true
        self.accessibleBraille = true
        self.accessibleHearing = true
        super.init(nibName: nil, bundle: nil)
    }
}
