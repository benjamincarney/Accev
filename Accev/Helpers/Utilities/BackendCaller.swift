//
//  BackendCaller.swift
//  Accev
//
//  Created by Benjamin Carney on 3/5/20.
//  Copyright © 2020 Accev. All rights reserved.
//
// A good place to throw any functions that will communicate with the backend
// ie creating pin, rating a pin, deleting a pin, etc
// swiftlint:disable all
import Firebase
import Foundation
import GoogleMaps

class BackendCaller {
    let database = Firestore.firestore()
    // TODO: Add new pin to database with associated information
    func addPinBackend(_ mapView: GMSMapView, _ coordinate: CLLocationCoordinate2D) -> String {
        var ref: DocumentReference? = nil
        ref = database.collection("pins").addDocument(data: [
            "longitude": coordinate.longitude,
            "latitude": coordinate.latitude,
            "upvotes": 0,
            "downvotes": 0,
            "isWheelChairAccessible": false
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        return ref!.documentID
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
    func pullPinsBackend(completion: @escaping (Dictionary<String, Dictionary<String, Any>>) -> Void) {
        var returnObject = Dictionary<String, Dictionary<String, Any>>()
        database.collection("pins").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    returnObject[document.documentID] = document.data()
                }
            }
            completion(returnObject)
        }
    }
}
// swiftlint:enable all
