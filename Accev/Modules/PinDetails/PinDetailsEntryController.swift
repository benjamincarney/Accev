//
//  PinDetailsEntryController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/7/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import CoreLocation
import Foundation
import GoogleMaps
import UIKit

class PinDetailsEntryController: UIViewController, UITextViewDelegate {

    var coordinate: CLLocationCoordinate2D?

    var pinInfo = [String: Any]()

    weak var delegate: PinEntryControllerDelegate?

    var mapView = GMSMapView()

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

    // FIXME: probably not the best way to do this
    let wcCheckbox = CheckBox()
    let hCheckbox = CheckBox()
    let bCheckbox = CheckBox()

    lazy var wcLabel = createAccessibilityLabel(inputText: "Wheelchair Accessible")
    lazy var wcStack = createAccessibilityStack(label: wcLabel, checkbox: wcCheckbox)

    lazy var hLabel = createAccessibilityLabel(inputText: "Hearing Accessible")
    lazy var hStack = createAccessibilityStack(label: hLabel, checkbox: hCheckbox)

    lazy var bLabel = createAccessibilityLabel(inputText: "Braille Accessible")
    lazy var bStack = createAccessibilityStack(label: bLabel, checkbox: bCheckbox)

    let pinSubmitButton: UIButton = {
        let submit = UIButton()
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.addTarget(self, action: #selector(submitPin), for: .touchUpInside)
        submit.setTitle("Submit", for: .normal)
        submit.setTitleColor(UIColor.white, for: .normal)
        submit.setTitleColor(UIColor.darkGray, for: .highlighted)
        submit.backgroundColor = Colors.behindGradient
        submit.layer.cornerRadius = 15.0
        submit.layer.borderWidth = 2.0
        submit.layer.borderColor = Colors.behindGradient.cgColor
        return submit
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        constrainViews()
    }

    @objc
    func submitPin() {
        // If user did not check any access. boxes, error
        if !wcCheckbox.isChecked && !hCheckbox.isChecked && !bCheckbox.isChecked {
            let submitMessage = "Pins must be accessible by at least one of the three methods."
            let pinSubmissionAlert = UIAlertController(title: "Error", message: submitMessage, preferredStyle: .alert)
            //  swiftlint:disable all
            pinSubmissionAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                return
            }))
            //  swiftlint:enable all
            self.present(pinSubmissionAlert, animated: true, completion: nil)
        }

        // Build the dictionary to store in backend
        pinInfo["longitude"] = self.coordinate?.longitude
        pinInfo["latitude"] = self.coordinate?.latitude
        pinInfo["name"] = pinNameField.text ?? "N/A"
        pinInfo["description"] = pinDescriptionField.text ?? "N/A"
        pinInfo["accessibleWheelchair"] = wcCheckbox.isChecked
        pinInfo["accessibleHearing"] = hCheckbox.isChecked
        pinInfo["accessibleBraille"] = bCheckbox.isChecked
        pinInfo["upvotes"] = 0
        pinInfo["downvotes"] = 0

        // Send created dictionary back to HomeController
        if let delegate = self.delegate {
            delegate.pinEntryControllerWillDismiss(pinEntryVC: self, mapView: self.mapView)
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

    /// Create a label to be displayed for accessibility information
    func createAccessibilityLabel(inputText: String) -> UILabel {
        let accessLabel = UILabel()
        accessLabel.text = inputText
        accessLabel.font = R.font.latoRegular(size: 20)
        accessLabel.textColor = Colors.behindGradient
        return accessLabel
    }

    /// Create a stackview to be displayed to combine accessibility label and checkbox
    func createAccessibilityStack(label: UILabel, checkbox: CheckBox) -> UIStackView {
        let accessStack = UIStackView()
        accessStack.axis = .horizontal
        accessStack.translatesAutoresizingMaskIntoConstraints = false
        accessStack.addArrangedSubview(label)
        accessStack.addArrangedSubview(checkbox)
        return accessStack
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

        // Configure targets & initial state for checkboxes
        wcCheckbox.addTarget(wcCheckbox, action: #selector(wcCheckbox.buttonClicked(sender:)), for: .touchUpInside)
        hCheckbox.addTarget(hCheckbox, action: #selector(hCheckbox.buttonClicked(sender:)), for: .touchUpInside)
        bCheckbox.addTarget(bCheckbox, action: #selector(bCheckbox.buttonClicked(sender:)), for: .touchUpInside)

        wcCheckbox.isChecked = false
        hCheckbox.isChecked = false
        bCheckbox.isChecked = false

        // Wheelchair label & checkbox
        view.addSubview(wcStack)

        // Hearing label & checkbox
        view.addSubview(hStack)

        // Braille label & checkbox
        view.addSubview(bStack)

        // Submit button
        view.addSubview(pinSubmitButton)
    }

    func constrainViews() {
        // Pin name
        constrainNameField()

        // Pin description
        constrainDescriptionField()

        // Wheelchair stuff
        constrainWheelchair()

        // Hearing stuff
        constrainHearing()

        // Braille stuff
        constrainBraille()

        // Submit button
        constrainSubmit()
    }

    func constrainNameField() {
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
    }

    func constrainDescriptionField() {
        pinDescriptionField.topAnchor.constraint(equalTo: pinNameField.bottomAnchor, constant: 20).isActive = true
        pinDescriptionField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        pinDescriptionField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        pinDescriptionField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        pinDescriptionField.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    func constrainWheelchair() {
        wcStack.translatesAutoresizingMaskIntoConstraints = false
        wcStack.topAnchor.constraint(equalTo: pinDescriptionField.bottomAnchor, constant: 20).isActive = true
        wcStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        wcStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        wcStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true

        wcCheckbox.translatesAutoresizingMaskIntoConstraints = false
        wcCheckbox.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func constrainHearing() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.topAnchor.constraint(equalTo: wcStack.bottomAnchor, constant: 10).isActive = true
        hStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        hStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        hStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true

        hCheckbox.translatesAutoresizingMaskIntoConstraints = false
        hCheckbox.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func constrainBraille() {
        bStack.translatesAutoresizingMaskIntoConstraints = false
        bStack.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 10).isActive = true
        bStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        bStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        bStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true

        bCheckbox.translatesAutoresizingMaskIntoConstraints = false
        bCheckbox.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func constrainSubmit() {
        pinSubmitButton.topAnchor.constraint(equalTo: bStack.bottomAnchor, constant: 40).isActive = true
        pinSubmitButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        pinSubmitButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        pinSubmitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        pinSubmitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
    }
}
