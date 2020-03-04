//
//  UILabel+attributes.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(
        _ text: String,
        attributes: [NSAttributedString.Key: Any],
        align: NSTextAlignment = .left
    ) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
        self.textAlignment = align
    }
}
