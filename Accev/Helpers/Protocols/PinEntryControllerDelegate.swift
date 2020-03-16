//
//  PinEntryControllerDelegate.swift
//  Accev
//
//  Created by Connor Svrcek on 3/16/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation
import GoogleMaps

protocol PinEntryControllerDelegate: class {
    func pinEntryControllerWillDismiss(pinEntryVC: PinDetailsEntryController, mapView: GMSMapView)
}
