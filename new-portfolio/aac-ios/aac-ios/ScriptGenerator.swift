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
        // Initialize a model session with base instructions
        self.session = LanguageModelSession(
            instructions: PromptTemplate.baseInstructions
        )
    }

    // Generate example script based on category using category-specific prompt template
    func generateScripts(for category: String) async throws -> [GeneratedScript] {
        // Use category-specific prompt template for better results
        let prompt = PromptTemplate.fullPrompt(for: category)
        
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


