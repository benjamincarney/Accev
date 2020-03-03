//
//  FontResource+orDefault.swift
//  Accev
//
//  Created by Benjamin Carney on 3/3/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import Rswift
import UIKit

extension FontResource {
    func orDefault(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
        return UIFont(resource: self, size: size) ??
               UIFont.preferredFont(forTextStyle: style)
    }
}
