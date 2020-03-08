//
//  MapHelperFunctions.swift
//  Accev
//
//  Created by Benjamin Carney on 3/7/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Foundation

class MapHelper {
    // returns level of opacity for each pin based on the ratio of upvotes to downvotes
    func determineOpacity(_ upvotes: Int, _ downvotes: Int) -> Float {
        if upvotes == 0 {
            return 0.2
        }
        let ratio: Float = Float(downvotes) / Float(upvotes)

        if 0.0 <= ratio && ratio < 0.1 {
            return 1
        } else if 0.1 <= ratio && ratio < 0.2 {
            return 0.9
        } else if 0.2 <= ratio && ratio < 0.3 {
            return 0.8
        } else if 0.3 <= ratio && ratio < 0.4 {
            return 0.7
        } else if 0.4 <= ratio && ratio < 0.5 {
            return 0.7
        } else if 0.5 <= ratio && ratio < 0.6 {
            return 0.5
        } else if 0.7 <= ratio && ratio < 0.8 {
            return 0.4
        } else if 0.8 <= ratio && ratio < 0.9 {
            return 0.3
        } else {
            return 0.2
        }
    }
    // returns the percent trust rating according to the ratio of upvotes to downvotes
    func calculateTrustRating(_ upvotes: Int, _ downvotes: Int) -> Int {
        if upvotes == 0 {
            return 0
        }
        let trustRating: Double = (Double(upvotes) / (Double(downvotes) + Double(upvotes))) * 100.0
        return Int(trustRating)
    }

    func testDetermineOpacity() {
        assert(determineOpacity(1000, 200) == 0.4)
        assert(determineOpacity(1000, 100) == 0.2)
        assert(determineOpacity(1000, 500) == 0.6)
    }
}
