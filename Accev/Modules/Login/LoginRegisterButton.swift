//
//  LoginRegisterButton.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class LoginRegisterButton: UIButton {
    let borderWidth: CGFloat = 4.0
    let cornerRadius: CGFloat = 15.0
    let textSize: CGFloat = 36.0

    convenience init(_ label: String, height: CGFloat) {
        self.init()
        setTitle(label, for: .normal)
        setTitleColor(Colors.mostlyOpaqueText, for: .normal)
        setTitleColor(Colors.seeThroughContrast, for: .disabled)
        setTitleColor(Colors.seeThroughContrast, for: .focused)
        setTitleColor(Colors.seeThroughContrast, for: .highlighted)
        setTitleColor(Colors.seeThroughContrast, for: .selected)

        layer.borderColor = Colors.seeThroughContrast.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true

        titleLabel?.font = R.font.latoBold(size: textSize)
    }
}
