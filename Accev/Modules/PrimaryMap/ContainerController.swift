//
//  PrimaryMap.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import FirebaseAuth
import GoogleMaps
import UIKit

class ContainerController: RoutedViewController {

    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }

    func configureHomeController() {
        let homeController = HomeController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }

    func configureMenuController() {
        if menuController == nil {
            // add our menu controller here
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    // swiftlint:disable all
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        if shouldExpand {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 100
            }, completion: nil)
        } else {
            // hide menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) {(_) in
                guard let menuOption = menuOption else {
                    return
                }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        animateStatusBar()
    }
    // swiftlint:enable all
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .profile:
            let controller = ProfileController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .leaderboard:
            let controller = LeaderboardController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .inbox:
            let controller = InboxController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .notifications:
            let controller = NotificationsController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .settings:
            let controller = SettingsController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .feedback:
            let controller = FeedbackController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .about:
            let controller = AboutController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .logout:
            do {
                try Auth.auth().signOut()
            } catch let err {
                // Present alert controller for error
                let errDesc = err.localizedDescription
                let errorAlert = UIAlertController(title: "Error", message: errDesc, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                print(err)
                return
            }
            self.routeTo(screen: .login, animatedWithOptions: .transitionCrossDissolve)
        }
    }
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

}

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
