//
//  SocialMediaLoginButton.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class SocialMediaLoginButton: UIButton {
    let borderWidth: CGFloat = 4.0
    let cornerRadius: CGFloat = 15.0
    let leftImageMargin: CGFloat = 10.0

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageRect = super.imageRect(forContentRect: contentRect)
        let titleRect = super.titleRect(forContentRect: contentRect)
        let insetsWidth = imageEdgeInsets.left + imageEdgeInsets.right +
                          titleEdgeInsets.left + titleEdgeInsets.right
        let contentWidth = imageRect.width + titleRect.width
        let remainingWidth = contentRect.width - insetsWidth - contentWidth
        return imageRect.offsetBy(dx: -remainingWidth / 2.0, dy: 0.0)
    }

    convenience init(_ label: String, height: CGFloat, textSize: CGFloat, image: UIImage) {
        self.init()
        setTitle(label, for: .normal)
        setTitleColor(Colors.seeThroughText, for: .normal)
        setTitleColor(Colors.seeThroughContrast, for: .disabled)
        setTitleColor(Colors.seeThroughContrast, for: .focused)
        setTitleColor(Colors.seeThroughContrast, for: .highlighted)
        setTitleColor(Colors.seeThroughContrast, for: .selected)

        setImage(image, for: .normal)

        layer.borderColor = Colors.seeThroughContrast.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius

        imageEdgeInsets.left = leftImageMargin

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true

        titleLabel?.font = R.font.latoRegular(size: textSize)
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
}
