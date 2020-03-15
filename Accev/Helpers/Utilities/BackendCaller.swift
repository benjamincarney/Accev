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
    func addPinBackend(_ mapView: GMSMapView, _ coordinate: CLLocationCoordinate2D,
                       _ pinData: Dictionary<String, Any>) -> String {
        var ref: DocumentReference? = nil
        print(pinData)
        ref = database.collection("pins").addDocument(data: [
            "longitude": coordinate.longitude,
            "latitude": coordinate.latitude,
            "upvotes": pinData["upvotes"]!,
            "downvotes": pinData["downvotes"]!,
            "accessibleWheelchair": pinData["accessibleWheelchair"]!,
            "accessibleBraille": pinData["accessibleBraille"]!,
            "accessibleHearing": pinData["accessibleHearing"]!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        return ref!.documentID
    }

    // Any other edits that might need to be made?
    func editPinBackend() {
        
    }
    
    // Use this when a user casts an upvote in the pin details view
    func upvotePin(_ documentID: String) {
        let sfReference = database.collection("pins").document(documentID)
        database.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldUpvote = sfDocument.data()?["upvotes"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }

            // Note: this could be done without a transaction
            //       by updating the population using FieldValue.increment()
            transaction.updateData(["upvotes": oldUpvote + 1], forDocument: sfReference)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
    
    // Use this when a user casts a downvote in the pin details view
    func downvotePin(_ documentID: String) {
        let sfReference = database.collection("pins").document(documentID)
        database.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldDownvote = sfDocument.data()?["downvotes"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }

            // Note: this could be done without a transaction
            //       by updating the population using FieldValue.increment()
            transaction.updateData(["downvotes": oldDownvote + 1], forDocument: sfReference)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }

    // TODO: When user upvotes/downvotes a pin, increment either property on backend
    func ratePinBackend() {
    }

    // This is what our dictionary for pins looks like
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
                    returnObject[document.documentID] = document.data()
                }
            }
            completion(returnObject)
        }
    }
    
    func addFeedbackBackend(_ feedback: String) {
        var ref: DocumentReference? = nil
        ref = database.collection("feedback").addDocument(data: [
            "feedback": feedback
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
// swiftlint:enable all
