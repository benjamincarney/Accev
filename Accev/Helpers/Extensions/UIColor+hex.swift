//
//  UIColor+hex.swift
//  Accev
//
//  Created by Benjamin Carney on 3/2/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
}
