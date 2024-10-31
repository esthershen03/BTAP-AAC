//
//  AppDelegate.swift
//  aac-ios
//
//  Created by Rhea Chitanand on 11/23/23.
//

import Foundation
import Firebase
import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var ref: DatabaseReference!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        ref = Database.database().reference()
        
        print("App has started via AppDelegate.")
        
        // Save test values
        saveTestValue("Test1")
        saveTestValue("Test2")
        saveTestValue("Test3")
        
        // Fetch and print test values
        fetchAndPrintTestValues()
        
        initializeGridDataIfNeeded()
        
        return true
    }

    
    func saveTestValue(_ value: String) {
       let newEntityRef = ref.child("TestEntity").childByAutoId()
        newEntityRef.setValue(["testValue": value]) { error, _ in
            if let error = error {
                print("Could not save \(value): \(error.localizedDescription)")
            } else {
                print("Saved: \(value)")
            }
        }
    }
    
    func fetchAndPrintTestValues() {
        let fetchRef = ref.child("TestEntity")
        fetchRef.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let valueDict = childSnapshot.value as? [String: Any],
                   let testValue = valueDict["testValue"] as? String {
                    print("Fetched Value: \(testValue)")
                }
            }
        } withCancel: { error in
            print("Could not fetch: \(error.localizedDescription)")
        }
    }
    
    func initializeGridDataIfNeeded() {
        let gridRef = ref.child("GridTileEntity")
        gridRef.observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                for i in 1...20 {
                    let newItem: [String: Any] = [
                        "labelText": String(i),
                        "orderIndex": Int(i - 1)
                    ]
                    gridRef.childByAutoId().setValue(newItem)
                }
                print("Initialized grid data.")
            }
        } withCancel: { error in
            print("Error initializing grid data: \(error.localizedDescription)")
        }
    }
}
