//
//  RoutedNavigationController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//
//  This class can be used as a superclass for any UINavigationControllers. It
//  provides a router property that, when set to a RootRouter, allows the controller
//  to navigate to a different screen. If router is not set, routeTo does not
//  do anything.

import UIKit

class RoutedNavigationController: UINavigationController {
    var router: RootRouter?
    func routeTo(screen: RootRouter.Screen,
                 animatedWithOptions options: UIView.AnimationOptions? = nil) {
        router?.transitionTo(screen: screen, animatedWithOptions: options)
    }
}
