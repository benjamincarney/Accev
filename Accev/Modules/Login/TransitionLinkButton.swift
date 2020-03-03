//
//  TransitionLinkButton.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class TransitionLinkButton: UIButton {
    let textSize: CGFloat = 25.0

    convenience init(_ title: String) {
        self.init(frame: .zero)
        setTitleColor(Colors.text, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = R.font.latoRegular(size: textSize)
        let buttonText = NSMutableAttributedString(string: title)
        buttonText.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: buttonText.string.count)
        )
        buttonText.addAttribute(
            .foregroundColor,
            value: Colors.text,
            range: NSRange(location: 0, length: buttonText.string.count)
        )
        setAttributedTitle(buttonText, for: .normal)
    }
}
