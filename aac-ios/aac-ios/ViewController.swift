//
//  ViewController.swift
//  aac-ios
//
//  Created by Rhea Chitanand on 11/23/23.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import UIKit

class ViewController: UIViewController {
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        self.save(value: "Test1")
        self.save(value: "Test2")
        self.save(value: "Test3")
        
        self.retrieveValues()
    }
}

extension ViewController {
    func save(value: String) {
        let ref = Database.database().reference()
        let newValueRef = ref.child("TestEntity").childByAutoId()
        let newValue: [String: Any] = ["testValue": value]
        newValueRef.setValue(newValue) { error, _ in
            if let error = error {
                print("Saving Error: \(error.localizedDescription)")
            } else {
                print("Saved: \(value)")
            }
        }
    }
    func retrieveValues() {
        let ref = Database.database().reference().child("TestEntity")
        ref.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let valueDict = childSnapshot.value as? [String: Any],
                   let testValue = valueDict["testValue"] as? String {
                    print(testValue)
                }
            }
        } withCancel: { error in
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}
        
