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
            You are a helpful assistant that writes short communication scripts for AAC users with aphasia.
            Each script should be concise, natural, and appropriate for the given category.
            Return a set of 5 short example scripts that a user might use on a daily basis in real life scenarios.
            For example, if the category was 'Restaurant', a reusable script could be 
            'Can I get a to-go box, please?'. Keep a polite, respectful tone.
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


