//
//  BackgroundGradient.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import UIKit

class BackgroundGradient: CAGradientLayer {
    // Private Functions
    private func addColors() {
        colors = [
            Colors.startBackgroundGradient.cgColor,
            Colors.endBackgroundGradient.cgColor
        ]
    }

    // Public Functions
    func addToView(_ view: UIView) {
        if let tableView = view as? UITableView {
            let bgView = UIView()
            tableView.backgroundView = bgView
            bgView.layer.insertSublayer(self, at: 0)
            bgView.backgroundColor = Colors.behindGradient
        } else {
            view.layer.insertSublayer(self, at: 0)
            view.backgroundColor = Colors.behindGradient
        }
    }

    func layoutInView(_ view: UIView) {
        self.frame = view.bounds
    }

    // Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addColors()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        addColors()
    }

    override init() {
        super.init()
        addColors()
    }
}
