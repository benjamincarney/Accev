//
//  RoutedViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class RoutedViewController: UIViewController {
    var router: RootRouter?
    func routeTo(screen: RootRouter.Screen, animatedWithOptions options: UIView.AnimationOptions? = nil) {
        router?.transitionTo(screen: screen, animatedWithOptions: options)
    }
}
