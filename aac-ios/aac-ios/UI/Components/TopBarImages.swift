//
//  TopBarImages.swift
//  aac-ios
//
//  Created by Sravya Paspunoori on 10/4/23.
//

import Foundation
import SwiftUI

struct TopBarImages: View {
    var body: some View {
        HStack {
            Button(action: {
                // Handle the action for the first button
                // For example, navigate to a view or perform an action
            }) {
                Text("Button 1")
                    .padding(10)
            }
            
            Button(action: {
                // Handle the action for the second button
            }) {
                Text("Button 2")
                    .padding(10)
            }
            
            Button(action: {
                // Handle the action for the third button
            }) {
                Text("Button 3")
                    .padding(10)
            }
            
            // Add more buttons as needed
        }
        .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
        .cornerRadius(10)
    }
}



