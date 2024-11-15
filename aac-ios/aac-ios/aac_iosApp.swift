//
//  aac_iosApp.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 8/25/23.
//

import SwiftUI
import CoreData

@main
struct aac_iosApp: App {
    @StateObject private var sdViewModel = SceneDisplayViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, sdViewModel.container.viewContext)
        }
    }
}

