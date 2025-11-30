//
//  PromptTemplate.swift
//  aac-ios
//
// Created by Samiya Pathak 11/01/25 
// Created for prompt engineering and template management
//

import Foundation

/// Provides category-specific prompt templates for script generation
struct PromptTemplate {
    
    /// Base instructions for the AI model
    static let baseInstructions = """
    You are a helpful assistant that writes short communication scripts for AAC users with aphasia.
    Each script should be:
    - Concise (1-2 sentences maximum)
    - Natural and conversational
    - Appropriate for daily real-life scenarios
    - Polite and respectful
    - Easy to understand and use
    - Practical for immediate communication needs
    
    Focus on scripts that help users express their needs, ask questions, or engage in common interactions.
    """
    
    /// Gets a category-specific prompt template
    /// - Parameter category: The category name
    /// - Returns: A tailored prompt for that category
    static func prompt(for category: String) -> String {
        let categoryLower = category.lowercased()
        
        // Category-specific prompt templates
        switch categoryLower {
        case "health", "medical":
            return """
            Generate 5 simple, conversational communication scripts for HEALTH/MEDICAL situations.
            Focus on scripts for:
            - Expressing symptoms or pain
            - Asking for medical help
            - Communicating during doctor visits
            - Requesting medication or assistance
            - Describing how you feel
            
            Each script should be 1-2 sentences and suitable for an AAC device user in medical settings.
            """
            
        case "food", "restaurant", "dining":
            return """
            Generate 5 simple, conversational communication scripts for FOOD/RESTAURANT situations.
            Focus on scripts for:
            - Ordering food or drinks
            - Expressing dietary preferences or restrictions
            - Asking about menu items
            - Requesting assistance (to-go box, check, etc.)
            - Communicating food preferences
            
            Each script should be 1-2 sentences and suitable for an AAC device user in dining situations.
            """
            
        case "activities", "recreation", "hobbies":
            return """
            Generate 5 simple, conversational communication scripts for ACTIVITIES/RECREATION.
            Focus on scripts for:
            - Suggesting activities to do
            - Expressing interest or preferences
            - Asking to join or participate
            - Requesting help with activities
            - Communicating enjoyment or preferences
            
            Each script should be 1-2 sentences and suitable for an AAC device user in recreational contexts.
            """
            
        case "tv", "entertainment", "media":
            return """
            Generate 5 simple, conversational communication scripts for TV/ENTERTAINMENT.
            Focus on scripts for:
            - Requesting to watch something
            - Changing channels or shows
            - Expressing preferences for content
            - Asking about what's on
            - Requesting volume or other controls
            
            Each script should be 1-2 sentences and suitable for an AAC device user.
            """
            
        case "shopping", "store", "retail":
            return """
            Generate 5 simple, conversational communication scripts for SHOPPING situations.
            Focus on scripts for:
            - Asking for help finding items
            - Asking about prices or availability
            - Requesting to try something on
            - Asking about sizes or options
            - Requesting checkout assistance
            
            Each script should be 1-2 sentences and suitable for an AAC device user in retail settings.
            """
            
        case "transportation", "travel", "transport":
            return """
            Generate 5 simple, conversational communication scripts for TRANSPORTATION/TRAVEL.
            Focus on scripts for:
            - Asking for directions
            - Requesting transportation assistance
            - Communicating destination
            - Asking about schedules or routes
            - Requesting help with luggage or mobility
            
            Each script should be 1-2 sentences and suitable for an AAC device user.
            """
            
        case "emergency", "help", "urgent":
            return """
            Generate 5 simple, conversational communication scripts for EMERGENCY situations.
            Focus on scripts for:
            - Requesting immediate help
            - Calling emergency services
            - Describing urgent situations
            - Asking for medical assistance
            - Communicating that help is needed
            
            Each script should be clear, direct, and 1-2 sentences suitable for urgent communication.
            """
            
        case "family", "friends", "social":
            return """
            Generate 5 simple, conversational communication scripts for FAMILY/SOCIAL interactions.
            Focus on scripts for:
            - Expressing feelings or emotions
            - Asking about others' well-being
            - Making plans or invitations
            - Sharing information or updates
            - Expressing care or concern
            
            Each script should be 1-2 sentences and suitable for personal communication.
            """
            
        case "work", "office", "professional":
            return """
            Generate 5 simple, conversational communication scripts for WORK/PROFESSIONAL settings.
            Focus on scripts for:
            - Requesting assistance or clarification
            - Communicating about tasks or projects
            - Asking for meetings or discussions
            - Expressing availability or needs
            - Professional communication needs
            
            Each script should be 1-2 sentences and suitable for workplace communication.
            """
            
        case "home", "household", "house":
            return """
            Generate 5 simple, conversational communication scripts for HOME/HOUSEHOLD situations.
            Focus on scripts for:
            - Requesting help with household tasks
            - Asking about household items or locations
            - Communicating needs at home
            - Requesting assistance with daily activities
            - Expressing preferences for home activities
            
            Each script should be 1-2 sentences and suitable for home communication.
            """
            
        case "bathroom", "restroom", "toilet":
            return """
            Generate 5 simple, conversational communication scripts for BATHROOM/RESTROOM needs.
            Focus on scripts for:
            - Requesting to use the restroom
            - Asking for assistance
            - Communicating bathroom-related needs
            - Requesting help finding facilities
            - Expressing urgent needs
            
            Each script should be clear, respectful, and 1-2 sentences suitable for private communication needs.
            """
            
        default:
            // Generic template for unknown categories
            return """
            Generate 5 simple, conversational communication scripts for the category: "\(category)".
            Focus on practical, everyday communication needs that would be useful for an AAC device user.
            Each script should be 1-2 sentences long and suitable for real-life scenarios in this category.
            """
        }
    }
    
    /// Gets the full prompt combining base instructions with category-specific template
    /// - Parameter category: The category name
    /// - Returns: Complete prompt for script generation
    static func fullPrompt(for category: String) -> String {
        return baseInstructions + "\n\n" + prompt(for: category)
    }
}

