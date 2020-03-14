//
//  PinDetailsController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/6/20.
//  Copyright © 2020 Accev. All rights reserved.
//  swiftlint:disable all

import UIKit

class PinDetailsController: UIViewController {

    var pinID: String?
    var upvotes: Int?
    var downvotes: Int?
    var accessibleBraille: Bool?
    var accessibleHearing: Bool?
    var accessibleWheelchair: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        navigationItem.title = "Pin Details"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24blue").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))
        

        self.view.addSubview(upvotesLabel)
        self.view.addSubview(downvotesLabel)
        self.view.addSubview(wheelchairLabel)
        self.view.addSubview(brailleLabel)
        self.view.addSubview(hearingLabel)
        self.view.addSubview(ratePinLabel)
        self.view.addSubview(upvoteButton)
        self.view.addSubview(downvoteButton)

        upvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        downvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        wheelchairLabel.translatesAutoresizingMaskIntoConstraints = false
        brailleLabel.translatesAutoresizingMaskIntoConstraints = false
        hearingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratePinLabel.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false

        upvotesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        upvotesLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 115).isActive = true
        
        let imageUp = UIImage(named: "thumbup24.png")
        let imageViewUp = UIImageView(image: imageUp)
        imageViewUp.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        view.addSubview(imageViewUp)
        imageViewUp.translatesAutoresizingMaskIntoConstraints = false
        imageViewUp.leftAnchor.constraint(equalTo: upvotesLabel.rightAnchor, constant: 10).isActive = true
        imageViewUp.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110).isActive = true

        downvotesLabel.leftAnchor.constraint(equalTo: imageViewUp.rightAnchor, constant: 20).isActive = true
        downvotesLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 114).isActive = true
        
        let imageDown = UIImage(named: "thumbdown24.png")
        let imageViewDown = UIImageView(image: imageDown)
        imageViewDown.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        view.addSubview(imageViewDown)
        imageViewDown.translatesAutoresizingMaskIntoConstraints = false
        imageViewDown.leftAnchor.constraint(equalTo: downvotesLabel.rightAnchor, constant: 10).isActive = true
        imageViewDown.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110).isActive = true
        
        wheelchairLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        wheelchairLabel.topAnchor.constraint(equalTo: upvotesLabel.bottomAnchor, constant: 40).isActive = true
        
        brailleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        brailleLabel.topAnchor.constraint(equalTo: wheelchairLabel.bottomAnchor, constant: 40).isActive = true
        
        hearingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        hearingLabel.topAnchor.constraint(equalTo: brailleLabel.bottomAnchor, constant: 40).isActive = true
        
        ratePinLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        ratePinLabel.topAnchor.constraint(equalTo: hearingLabel.bottomAnchor, constant: 40).isActive = true
        
        upvoteButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10).isActive = true
        upvoteButton.topAnchor.constraint(equalTo: ratePinLabel.bottomAnchor, constant: 40).isActive = true
        downvoteButton.leftAnchor.constraint(equalTo: upvoteButton.rightAnchor, constant: 30).isActive = true
        downvoteButton.topAnchor.constraint(equalTo: ratePinLabel.bottomAnchor, constant: 40).isActive = true

        if self.accessibleWheelchair! {
            let image = UIImage(named: "cross32.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
            imageView.topAnchor.constraint(equalTo: upvotesLabel.bottomAnchor, constant: 40).isActive = true
        } else {
            let image = UIImage(named: "check32.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
            imageView.topAnchor.constraint(equalTo: upvotesLabel.bottomAnchor, constant: 40).isActive = true
        }
        if self.accessibleBraille! {
            let image = UIImage(named: "cross32.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
            imageView.topAnchor.constraint(equalTo: wheelchairLabel.bottomAnchor, constant: 40).isActive = true
        } else {
            let image = UIImage(named: "check32.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
            imageView.topAnchor.constraint(equalTo: wheelchairLabel.bottomAnchor, constant: 40).isActive = true
        }
        if self.accessibleHearing! {
            let image = UIImage(named: "cross32.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
            imageView.topAnchor.constraint(equalTo: brailleLabel.bottomAnchor, constant: 40).isActive = true
        } else {
            let image = UIImage(named: "check32.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
            imageView.topAnchor.constraint(equalTo: brailleLabel.bottomAnchor, constant: 40).isActive = true
        }
    }

    @objc
    func downvoteButtonTapped() {
        let backend = BackendCaller()
        backend.downvotePin(self.pinID!)
        self.downvotes! += 1
        downvotesLabel.text = "\(Int(self.downvotes!))"
        let alert = UIAlertController(title: "Feedback received", message: "Thanks for rating!", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            self.handleDismiss()
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    @objc
    func upvoteButtonTapped() {
        let backend = BackendCaller()
        backend.upvotePin(self.pinID!)
        self.upvotes! += 1
        upvotesLabel.text = "\(Int(self.upvotes!))"
        let alert = UIAlertController(title: "Feedback received", message: "Thanks for rating!", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            self.handleDismiss()
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    lazy var downvoteButton: UIButton = {
        let image = UIImage(named: "thumbdown64.png")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        button.setBackgroundImage(image, for: .normal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(downvoteButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var upvoteButton: UIButton = {
        let image = UIImage(named: "thumbup64.png")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        button.setBackgroundImage(image, for: .normal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(upvoteButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var wheelchairLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "Wheelchair Accessible"
        label.textColor = Colors.behindGradient
        label.font = R.font.latoRegular(size: 25)
        return label
    }()

    lazy var brailleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "Braille Accessible"
        label.textColor = Colors.behindGradient
        label.font = R.font.latoRegular(size: 25)
        return label
    }()

    lazy var hearingLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "Hearing Accessible"
        label.textColor = Colors.behindGradient
        label.font = R.font.latoRegular(size: 25)
        return label
    }()
    
    lazy var ratePinLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "Rate this pin!"
        label.textColor = Colors.behindGradient
        label.font = UIFont.boldSystemFont(ofSize: 35.0)
        return label
    }()

    lazy var upvotesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "\(Int(self.upvotes!))"
        label.textColor = UIColor(red: 70.0 / 255.0, green: 151.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
        label.font = R.font.latoRegular(size: 17)
        return label
    }()

    lazy var downvotesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "\(Int(self.downvotes!))"
        label.textColor = UIColor(red: 207.0 / 255.0, green: 15.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
        label.font = R.font.latoRegular(size: 17)
        return label
    }()

    lazy var crossImage: UIImage = {
        let image = UIImage(named: "cross32.png")
        return image!
    }()

    lazy var checkImage: UIImage = {
        let image = UIImage(named: "check32.png")
        return image!
    }()
}
// swiftlint:enable all
