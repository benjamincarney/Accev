//
//  RootRouter.swift
//  Accev
//
//  Copyright © Accev. All rights reserved.
//

import UIKit

class RootRouter {
    enum Screen {
        case forgotPassword
        case login
        case register
        case setupProfile
        case primaryMap
    }
    private lazy var loginVC: UIViewController = {
        let controller = LoginViewController()
        controller.router = self
        return controller
    }()
    private lazy var registerVC: UIViewController = {
        let controller = RegisterViewController()
        controller.router = self
        return controller
    }()
    private lazy var setUpProfileVC: UIViewController = {
        let controller = SetupProfileViewController()
        controller.router = self
        return controller
    }()
    private lazy var forgotPasswordVC: UIViewController = {
        let controller = ForgotPasswordViewController()
        controller.router = self
        return controller
    }()
    private lazy var primaryMapVC: UIViewController = {
        let controller = ContainerController()
        controller.router = self
        return controller
    }()

    func transitionTo(screen: Screen, animatedWithOptions: UIView.AnimationOptions?) {
        var controller: UIViewController
        switch screen {
        case .login:
            controller = loginVC
        case .setupProfile:
            controller = setUpProfileVC
        case .forgotPassword:
            controller = forgotPasswordVC
        case .register:
            controller = registerVC
        case .primaryMap:
            controller = primaryMapVC
        }
        setRootViewController(controller: controller,
                              animatedWithOptions: animatedWithOptions)
    }

    /** Replaces root view controller. You can specify the replacment animation type.
     If no animation type is specified, there is no animation */
    func setRootViewController(controller: UIViewController, animatedWithOptions: UIView.AnimationOptions?) {
        guard let window = UIApplication.shared.keyWindow else {
            fatalError("No window in app")
        }
        if let animationOptions = animatedWithOptions, window.rootViewController != nil {
            window.rootViewController = controller
            UIView.transition(with: window, duration: 0.33, options: animationOptions, animations: {
            }, completion: nil)
        } else {
            window.rootViewController = controller
        }
    }

    func loadMainAppStructure() {
        // let isLoggedIn = Auth.auth().currentUser != nil
        var controller: UIViewController

//        if isLoggedIn {
//            controller = primaryMapVC
//        } else {
            controller = loginVC
        //}
        setRootViewController(controller: controller, animatedWithOptions: nil)
    }
}
