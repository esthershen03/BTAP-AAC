//
//  ScriptGenerator.swift
//  aac-ios
//
//  Created by Dahyun on 11/5/25.
//

import FoundationModels

@MainActor
final class ScriptGenerator {
    private let session: LanguageModelSession

    init() {
        // Initialize a model session with clear instructions for the AI
        self.session = LanguageModelSession(
            instructions: """
                You are an empathetic language assistant that writes short, natural communication scripts for AAC (Augmentative and Alternative Communication) users, including those with aphasia.

                Your goal is to help users express themselves clearly and politely in everyday social situations.
                - Each script should sound conversational, practical, and easy to speak aloud.
                - Avoid complex words or long phrases.
                - Use a friendly and respectful tone that works in real life (e.g., at home, in public, at work, or in care settings).
                - Keep sentences short (usually one to two sentences).
                - Ensure diversity: mix statements, questions, and common requests that match the category.
                - Do not include quotes, numbers, or extra formatting—just the plain text scripts.

                When asked to generate scripts for a category (for example, “Restaurant”), return a set of five short, distinct example scripts the user could realistically use in that situation.
                Example (Restaurant):
                - Can I get a table for two, please?
                - Could I have some water?
                - I’d like to see the menu.
                - Can I get a to-go box, please?
                - Thank you for your help!

                Keep all responses concise, human-like, and accessible.
    """

        )
    }

    // Generate example script based on category
    func generateScripts(for category: String) async throws -> [GeneratedScript] {
        let prompt = """
        Generate 5 simple, conversational communication scripts for the category: "\(category)".
        Each script should be 1–2 sentences long and suitable for an AAC device user.
        """
        
        let result = try await session.respond(
            to: prompt,
            generating: ScriptBatch.self
        )

        return result.content.scripts
    }
}

// MARK: - Generable Structures
@Generable
struct ScriptBatch {
    @Guide(description: "An array of short, natural communication scripts for the given category.", .count(5))
    var scripts: [GeneratedScript]
}

@Generable
struct GeneratedScript {
    @Guide(description: "A concise, natural sentence expressing something within this category.")
    var text: String
}


