//
//  PinDetailsController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/6/20.
//  Copyright © 2020 Accev. All rights reserved.
//

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

        upvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        downvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        wheelchairLabel.translatesAutoresizingMaskIntoConstraints = false
        brailleLabel.translatesAutoresizingMaskIntoConstraints = false
        hearingLabel.translatesAutoresizingMaskIntoConstraints = false

        upvotesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        upvotesLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110).isActive = true

        downvotesLabel.leftAnchor.constraint(equalTo: upvotesLabel.rightAnchor, constant: 20).isActive = true
        downvotesLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110).isActive = true
        
        wheelchairLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        wheelchairLabel.topAnchor.constraint(equalTo: upvotesLabel.bottomAnchor, constant: 40).isActive = true
        
        brailleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        brailleLabel.topAnchor.constraint(equalTo: wheelchairLabel.bottomAnchor, constant: 40).isActive = true
        
        hearingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        hearingLabel.topAnchor.constraint(equalTo: brailleLabel.bottomAnchor, constant: 40).isActive = true

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
        // send to backend
    }

    @objc
    func upvoteButtonTapped() {
        // send to backend
    }

    lazy var downvoteButton: UIButton = {
        let image = UIImage(named: "thumbdown32.png")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setBackgroundImage(image, for: .normal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(upvoteButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var upvoteButton: UIButton = {
        let image = UIImage(named: "thumbup32.png")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setBackgroundImage(image, for: .normal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(downvoteButtonTapped), for: .touchUpInside)
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

    lazy var upvotesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "\(Int(self.upvotes!)) upvotes"
        label.textColor = UIColor(red: 70.0 / 255.0, green: 151.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
        label.font = R.font.latoRegular(size: 17)
        return label
    }()

    lazy var downvotesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "\(Int(self.downvotes!)) downvotes"
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
