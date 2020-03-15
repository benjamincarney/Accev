//
//  MenuOption.swift
//  Accev
//
//  Created by Benjamin Carney on 3/5/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {

    case profile
    case inbox
    case notifications
    case settings
    case feedback
    case about
    case logout

    var description: String {
        switch self {
        case .profile:
            return "Profile"
        case .inbox:
            return "Inbox"
        case .notifications:
            return "Notifications"
        case .settings:
            return "Settings"
        case .feedback:
            return "Feedback"
        case .about:
            return "About"
        case .logout:
            return "Logout"
        }
    }

    var image: UIImage {
        switch self {
        case .profile:
            return UIImage(named: "ic_person_outline_white_2x") ?? UIImage()
        case .inbox:
            return UIImage(named: "ic_mail_outline_white_2x") ?? UIImage()
        case .notifications:
            return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .settings:
            return UIImage(named: "baseline_settings_white_24dp") ?? UIImage()
        case .feedback:
            return UIImage(named: "feedback48.png") ?? UIImage()
        case .about:
            return UIImage(named: "info48.png") ?? UIImage()
        case .logout:
            return UIImage(named: "logout48.png") ?? UIImage()
        }
    }
}
