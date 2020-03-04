//
//  LoginTextField.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    let cornerRadius: CGFloat = 15.0
    let height: CGFloat = 67.0
    let textInsetX: CGFloat = 15.0
    let textSize: CGFloat = 36.0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInsetX, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInsetX, dy: 0)
    }

    convenience init(_ textContent: String, isSecure: Bool, isEmail: Bool) {
        self.init()
        heightAnchor.constraint(equalToConstant: height).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = cornerRadius
        backgroundColor = Colors.seeThroughContrast
        textColor = Colors.text

        if isEmail {
            autocapitalizationType = .none
            keyboardType = .emailAddress
        }
        isSecureTextEntry = isSecure
        let inputFont = R.font.latoBold(size: textSize)
        font = inputFont

        if let font = inputFont {
            attributedPlaceholder = NSAttributedString(string: textContent,
                attributes: [
                    .foregroundColor: Colors.seeThroughText,
                    .font: font
                ]
            )
        }
        if #available(iOS 12, *) {
            self.textContentType = .oneTimeCode
        } else {
            self.textContentType = .init(rawValue: "")
        }
    }
}
