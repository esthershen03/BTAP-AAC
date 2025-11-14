//
//  ScriptGenerationViewModel.swift
//  aac-ios
//
//  Created for handling async generating/fetching generated scripts
//

import Foundation
import SwiftUI

@MainActor
class ScriptGenerationViewModel: ObservableObject {
    @Published var scripts: [String] = []
    @Published var isGenerating: Bool = false
    @Published var errorMessage: String?
    
    private let scriptGenerator: ScriptGenerator
    private let scriptsViewModel: ScriptsViewModel
    private var currentCategory: String?
    
    init(scriptGenerator: ScriptGenerator = ScriptGenerator(), 
         scriptsViewModel: ScriptsViewModel = ScriptsViewModel()) {
        self.scriptGenerator = scriptGenerator
        self.scriptsViewModel = scriptsViewModel
    }
    
    /// Fetches existing scripts for a given category
    /// - Parameter category: The category name to fetch scripts for
    func fetchScripts(for category: String) async {
        guard !category.isEmpty else { return }
        
        currentCategory = category
        
        // Load existing scripts for this category if available
        if let savedScripts = scriptsViewModel.loadScripts(),
           let existingScripts = savedScripts[category],
           !existingScripts.isEmpty {
            scripts = existingScripts
        } else {
            // Initialize with empty scripts if none exist
            scripts = Array(repeating: "", count: 6)
        }
    }
    
    /// Generates new AI scripts for the given category
    /// - Parameter category: The category name to generate scripts for
    func generateScripts(for category: String) async {
        guard !category.isEmpty else { return }
        
        isGenerating = true
        errorMessage = nil
        
        do {
            let generatedScripts = try await scriptGenerator.generateScripts(for: category)
            scripts = generatedScripts.map { $0.text }
            
            // Save generated scripts
            saveScripts(for: category)
        } catch {
            errorMessage = "Failed to generate scripts: \(error.localizedDescription)"
            print("⚠️ Script generation error: \(error)")
        }
        
        isGenerating = false
    }
    
    /// Refreshes the scripts for the current category
    func refreshScripts() async {
        guard let category = currentCategory else { return }
        await generateScripts(for: category)
    }
    
    /// Updates a script at a specific index
    /// - Parameters:
    ///   - text: The new script text
    ///   - index: The index of the script to update
    func updateScript(_ text: String, at index: Int) {
        guard index >= 0 && index < scripts.count else { return }
        scripts[index] = text
    }
    
    /// Saves the current scripts to persistent storage
    /// - Parameter category: The category name to save scripts for
    func saveScripts(for category: String) {
        guard !category.isEmpty else { return }
        
        // Load existing category texts
        var categoryTexts = scriptsViewModel.loadScripts() ?? [:]
        categoryTexts[category] = scripts
        scriptsViewModel.saveScripts(categoryTexts)
    }
    
    /// Clears the current scripts and error state
    func clear() {
        scripts = []
        errorMessage = nil
        currentCategory = nil
        isGenerating = false
    }
}

