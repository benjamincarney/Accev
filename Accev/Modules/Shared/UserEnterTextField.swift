//
//  UserEnterTextField.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class UserEnterTextField: UITextField {
    let cornerRadius: CGFloat = 15.0
    let height: CGFloat
    let textInsetX: CGFloat = 15.0
    let textSize: CGFloat = 36.0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInsetX, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInsetX, dy: 0)
    }

     init(_ textContent: String, height: CGFloat = 67.0) {
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        backgroundColor = Colors.seeThroughContrast
        textColor = Colors.text

        let inputFont = R.font.latoRegular(size: textSize)
        font = inputFont

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true

        if let font = inputFont {
            attributedPlaceholder = NSAttributedString(
                string: textContent,
                attributes: [
                    .foregroundColor: Colors.seeThroughText,
                    .font: font
                ]
            )
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
