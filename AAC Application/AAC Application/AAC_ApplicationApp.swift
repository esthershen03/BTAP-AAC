//
//  AAC_ApplicationApp.swift
//  AAC Application
//
//  Created by Shreya Puvvula on 9/30/23.
//

import SwiftUI
import CoreData

@main
@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
struct AAC_ApplicationApp: App {
    var appDelegate = AppDelegate()
    let persistentContainer: NSPersistentContainer

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not cast UIApplication.shared.delegate to AppDelegate")
        }
        self.persistentContainer = appDelegate.persistentContainer
    }
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                Scripts()
                    environment(\.managedObjectContext, appDelegate.persistentContainer.viewContext)
            } else {
                Login()
            }
        }
    }
}
