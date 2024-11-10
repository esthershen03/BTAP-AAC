//
//  AppDelegate.swift
//  aac-ios
//
//  Created by Rhea Chitanand on 11/23/23.
//

import Foundation
import CoreData
import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveTestValue(_ value: String) {
        let context = persistentContainer.viewContext
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "TestEntity", into: context)
        newEntity.setValue(value, forKey: "testValue")
        do {
            try context.save()
            print("Saved: \(value)")
        } catch {
            print("Could not save \(value): \(error)")
        }
    }
    
    func fetchAndPrintTestValues() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TestEntity")
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                guard let testValue = (managedObject as? NSManagedObject)?.value(forKey: "testValue") as? String else { continue }
                print("Fetched Value: \(testValue)")
            }
        } catch {
            print("Could not fetch: \(error)")
        }
    }
    
    func initializeGridDataIfNeeded() {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<GridTileEntity> = GridTileEntity.fetchRequest()
            do {
                let count = try context.count(for: fetchRequest)
                if count == 0 {
                    for i in 1...20 {
                        let newItem = GridTileEntity(context: context)
                        newItem.labelText = String(i)
                        newItem.orderIndex = Int16(i - 1)
                    }
                    try context.save()
                }
            } catch {
                print("Error initializing grid data: \(error)")
            }
        }
}
