//
//  SampleScripts.swift
//  aac-ios
//
//  Created for pre-populating the app with curated sample scripts
//

import Foundation

/// Provides curated sample scripts for each category to pre-populate the app
struct SampleScripts {
    
    /// Sample scripts organized by category
    static let scripts: [String: [String]] = [
        "Health": [
            "I'm not feeling well today.",
            "Can you help me with my medication?",
            "I need to see a doctor.",
            "Where is the nearest hospital?",
            "I'm in pain and need help.",
            "Can you call an ambulance?"
        ],
        "Food": [
            "I'm hungry. Can we get something to eat?",
            "I'd like to order a meal, please.",
            "Do you have any vegetarian options?",
            "Can I get a to-go box, please?",
            "I'm allergic to nuts.",
            "Can I see the menu?"
        ],
        "Activities": [
            "Would you like to go for a walk?",
            "I'd like to do something fun today.",
            "Can we play a game together?",
            "I enjoy reading and listening to music.",
            "Let's go outside and enjoy the weather.",
            "What activities do you recommend?"
        ],
        "TV": [
            "Can we watch something together?",
            "I'd like to change the channel.",
            "Can you turn up the volume, please?",
            "What shows are on right now?",
            "I prefer watching documentaries.",
            "Can we find something to watch?"
        ],
        "Restaurant": [
            "I'd like a table for two, please.",
            "Can I see the menu?",
            "I'll have the special, please.",
            "Can I get the check, please?",
            "This is delicious, thank you.",
            "Do you have any recommendations?"
        ],
        "Shopping": [
            "Can you help me find this item?",
            "Do you have this in a different size?",
            "How much does this cost?",
            "Can I try this on?",
            "Where is the checkout counter?",
            "Do you accept credit cards?"
        ],
        "Transportation": [
            "Can you help me get a taxi?",
            "Which bus goes to the city center?",
            "I need directions to the airport.",
            "Can you help me with my luggage?",
            "What time does the next train leave?",
            "I need assistance getting on the bus."
        ],
        "Emergency": [
            "I need help right away!",
            "Please call 911.",
            "Can someone help me?",
            "I'm having a medical emergency.",
            "I need immediate assistance.",
            "Please get help quickly."
        ],
        "Family": [
            "How are you doing today?",
            "I love you and miss you.",
            "Can we spend time together?",
            "I'm happy to see you.",
            "Thank you for your help.",
            "I appreciate everything you do."
        ],
        "Work": [
            "Can we schedule a meeting?",
            "I need help with this project.",
            "Can you clarify the instructions?",
            "I'll have that ready by tomorrow.",
            "Can we discuss this later?",
            "I'm available to help with that."
        ],
        "Home": [
            "Can you help me with this?",
            "Where did I put my keys?",
            "I need help around the house.",
            "Can we clean up together?",
            "I'd like to rest for a while.",
            "What would you like for dinner?"
        ],
        "Bathroom": [
            "I need to use the restroom.",
            "Where is the bathroom?",
            "Can you help me find the restroom?",
            "I need assistance, please.",
            "Is the restroom available?",
            "Thank you for your help."
        ]
    ]
    
    /// Default categories with their SF Symbol icons
    static let defaultCategories: [String] = [
        "Health",
        "Food",
        "Restaurant",
        "Shopping",
        "Transportation",
        "Activities",
        "Emergency",
        "Family",
        "TV",
        "Work",
        "Home",
        "Bathroom"
    ]
    
    /// SF Symbol icons for each category
    static let categoryIcons: [String: String] = [
        "Health": "heart.text.clipboard.fill",
        "Food": "fork.knife",
        "Restaurant": "fork.knife.circle.fill",
        "Shopping": "cart.fill",
        "Transportation": "car.fill",
        "Activities": "figure.run",
        "Emergency": "exclamationmark.triangle.fill",
        "Family": "person.2.fill",
        "TV": "play.tv.fill",
        "Work": "briefcase.fill",
        "Home": "house.fill",
        "Bathroom": "toilet.fill"
    ]
    
    /// Gets sample scripts for a category
    /// - Parameter category: The category name
    /// - Returns: Array of sample scripts, or empty array if not found
    static func getScripts(for category: String) -> [String] {
        return scripts[category] ?? []
    }
    
    /// Gets the icon for a category
    /// - Parameter category: The category name
    /// - Returns: SF Symbol name, or default icon if not found
    static func getIcon(for category: String) -> String {
        return categoryIcons[category] ?? "rectangle.fill"
    }
}

