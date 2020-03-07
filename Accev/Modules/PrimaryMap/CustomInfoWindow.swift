//
//  CustomInfoWindow.swift
//  Accev
//
//  Created by Benjamin Carney on 3/6/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit
import GoogleMaps

class CustomInfoWindow: UIView {
    let textSize: CGFloat = 20.0

    convenience init(_ title: String, _ mapView: GMSMapView, _ marker: GMSMarker) {
        self.init(frame: .zero)

    }
}
