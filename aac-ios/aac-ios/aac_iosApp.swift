//
//  aac_iosApp.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 8/25/23.
//

import SwiftUI
import Firebase

@main
struct aac_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
    }
}

