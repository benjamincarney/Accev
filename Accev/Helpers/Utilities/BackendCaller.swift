//
//  BackendCaller.swift
//  Accev
//
//  Created by Benjamin Carney on 3/5/20.
//  Copyright © 2020 Accev. All rights reserved.
//
// A good place to throw any functions that will communicate with the backend
// ie creating pin, rating a pin, deleting a pin, etc

import Foundation


// TODO: Add new pin to database with associated information
func addPinBackend() {
}

// TODO:
func editPinBackend() {
    
}

// TODO: When user upvotes/downvotes a pin, increment either property on backend
func ratePinBackend() {
    
}

// TODO: Return a dictionary of dictionaries? Outer Key represents some unique identifier
// Inner keys represent associated properties, for example:
// {
//  id432343: {locationName: Krusty Krab, upvotes: 423, downvotes: 21, wheelchairRamp: true}
//  id134854: {locationName: Chum Bucket, upvotes: 0, downvotes: 53, wheelchairRamp: false}
// }
func pullPinsBackend() -> Dictionary<String, Dictionary<String, Any>> {
    return [:]
}
