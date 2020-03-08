//
//  LocationPin.swift
//  Accev
//
//  Created by Benjamin Carney on 3/6/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation

// probably some sort of struct that captures all of the
// important information on pin, ie longitude, latitude, name,
// uniqID, creator, rating etc
struct LocationPin {
    var name: String
    var pinID: String
    var description: String
    var latitude: Double
    var longitude: Double
    var upvotes: Int
    var downvotes: Int
    var accessibleWheelchair: Bool
    var accessibleBraille: Bool
    var accessibleHearing: Bool
    var submittedBy: String
}
