//
//  PinDetailsEntryController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/7/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import UIKit

class PinDetailsEntryController: UIViewController, UITextViewDelegate {

    var pinID: String?

    lazy var pinNameField: UITextField = {
        let nameField = UITextField()
        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [
            .foregroundColor: UIColor.lightGray
        ])
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        nameField.leftViewMode = .always
        nameField.font = R.font.latoRegular(size: 25)
        nameField.textColor = Colors.behindGradient
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.layer.cornerRadius = 15.0
        nameField.layer.borderWidth = 2.0
        nameField.layer.borderColor = Colors.behindGradient.cgColor
        nameField.returnKeyType = .done
        return nameField
    }()

    // FIXME: desc
    lazy var pinDescriptionField: UITextView = {
        let desc = UITextView()
        desc.textContainerInset = UIEdgeInsets(top: 15, left: 8, bottom: 0, right: 0)
        desc.font = R.font.latoRegular(size: 25)
        desc.text = "Description"
        desc.textColor = UIColor.lightGray
        desc.backgroundColor = Colors.seeThroughText // FIXME: not a great color
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.layer.cornerRadius = 15.0
        desc.layer.borderWidth = 2.0
        desc.layer.borderColor = Colors.behindGradient.cgColor
        desc.delegate = self
        desc.selectedTextRange = desc.textRange(from: desc.beginningOfDocument, to: desc.beginningOfDocument)
        desc.returnKeyType = .done
        return desc
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

    // Text view (description) delegate
    // swiftlint:disable line_length

    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Copied from https://stackoverflow.com/questions/27652227/how-can-i-add-placeholder-text-inside-of-a-uitextview-in-swift

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Description"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = Colors.behindGradient
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    // swiftlint:enable line_length

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
        view.addSubview(pinNameField)

        // Pin description
        view.addSubview(pinDescriptionField)
    }

    func constrainViews() {
        // Pin name
        if #available(iOS 11.0, *) {
            pinNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            // Fallback on earlier versions
            pinNameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        }
        pinNameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        pinNameField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        pinNameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        pinNameField.heightAnchor.constraint(equalToConstant: 75).isActive = true

        // Pin description
        pinDescriptionField.topAnchor.constraint(equalTo: pinNameField.bottomAnchor, constant: 50).isActive = true
        pinDescriptionField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        pinDescriptionField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        pinDescriptionField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        pinDescriptionField.heightAnchor.constraint(equalToConstant: 175).isActive = true
    }
}
