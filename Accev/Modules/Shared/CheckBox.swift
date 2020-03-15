//
//  CheckBox.swift
//  Accev
//
//  Created by Connor Svrcek on 3/15/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    // Members

    let checked: UIImage = R.image.checkedCheckbox() ?? UIImage()
    let unchecked: UIImage = R.image.uncheckedCheckbox() ?? UIImage()

    var isChecked = false {
        didSet {
            if isChecked {
                self.setImage(checked, for: .normal)
            } else {
                self.setImage(unchecked, for: .normal)
            }
        }
    }

    @objc
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
