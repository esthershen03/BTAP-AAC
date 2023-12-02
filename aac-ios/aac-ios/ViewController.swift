//
//  ViewController.swift
//  aac-ios
//
//  Created by Rhea Chitanand on 11/23/23.
//

import Foundation
import SwiftUI
import CoreData
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.save(value: "Test1")
        self.save(value: "Test2")
        self.save(value: "Test3")
        
        self.retrieveValues()
    }
}

extension ViewController {
    func save(value: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "TestEntity", in:
                                                                        context) else { return }
            let newValue = NSManagedObject(entity: entityDescription,
                                           insertInto: context)
            newValue.setValue(value, forKey: "testValue")
            do {
                try context.save()
                print("Saved: (value)")
            } catch {
                print("Saving Error")
            }
        }
    }
    func retrieveValues() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<TestEntity>(entityName: "TestEntity")
            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    if let testValue = result.testValue {
                        print(testValue)
                    }
                }
            } catch {
                print("Could not retrieve")
            }
            
        }
    }
}
        
