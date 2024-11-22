//
//  ScriptsViewModel.swift
//  aac-ios
//
//  Created by Asma on 4/17/24.
//

import Foundation
import CoreData

class ScriptsViewModel: ObservableObject {
    private let key = "scripts"
    private let key2 = "scriptOrder"
    private let container: NSPersistentContainer
        
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    init() {
        self.container = NSPersistentContainer(name: "Model")
    }

    func saveScripts(_ categoryTexts: [String: [String]]?) {
        guard let categoryTexts = categoryTexts else {
            UserDefaults.standard.set(nil, forKey: key)
            return
        }
        do {
            let data = try JSONEncoder().encode(categoryTexts)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error encoding scripts data: \(error)")
        }
    }

    func loadScripts() -> [String: [String]]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let categoryTexts = try JSONDecoder().decode([String: [String]].self, from: data)
                return categoryTexts
            } catch {
                print("Error decoding scripts data from UserDefaults: \(error)")
                return nil
            }
        }
        let fetchRequest: NSFetchRequest<ScriptsEntity> = ScriptsEntity.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            var scriptsDict: [String: [String]] = [:]
            for script in result {
                if let category = script.category, let scriptText = script.scriptText {
                    scriptsDict[category] = scriptText.split(separator: ",").map { String($0) }
                }
            }
            return scriptsDict
        } catch {
            print("Failed to fetch scripts from Core Data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveOrder(_ categoryOrder: [Int: String]?) {
        guard let categoryOrder = categoryOrder else {
            UserDefaults.standard.set(nil, forKey: key2)
            return
        }
        do {
            let data = try JSONEncoder().encode(categoryOrder)
            UserDefaults.standard.set(data, forKey: key2)
        } catch {
            print("Error encoding script order data: \(error)")
        }
    }
    
    func loadOrder() -> [Int: String]? {
        if let data = UserDefaults.standard.data(forKey: key2) {
            do {
                let categoryOrder = try JSONDecoder().decode([Int: String].self, from: data)
                return categoryOrder
            } catch {
                print("Error decoding script order data: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func saveScriptsToCoreData(_ categoryTexts: [String: [String]]?) {
        guard let categoryTexts = categoryTexts else {
            print("No category texts provided")
            return
        }

        let context = container.viewContext
        // Clear any existing data
        let fetchRequest: NSFetchRequest<ScriptsEntity> = ScriptsEntity.fetchRequest()
        let existingScripts = try? context.fetch(fetchRequest)
        existingScripts?.forEach { context.delete($0) }

        // Save new data
        for (category, scripts) in categoryTexts {
            let scriptEntity = ScriptsEntity(context: context)
            scriptEntity.category = category
            scriptEntity.scriptText = scripts.joined(separator: ",")
        }
        
        do {
            try context.save()
            print("Scripts saved to Core Data")
        } catch {
            print("Error saving scripts to Core Data: \(error)")
        }
    }
    
    func saveOrderToCoreData(_ categoryOrder: [Int: String]?) {
        guard let categoryOrder = categoryOrder else {
            print("No category order provided")
            return
        }

        let context = container.viewContext
        let fetchRequest: NSFetchRequest<ScriptsEntity> = ScriptsEntity.fetchRequest()
        let existingScripts = try? context.fetch(fetchRequest)
        existingScripts?.forEach { context.delete($0) }

        for (num, category) in categoryOrder {
            let scriptEntity = ScriptsEntity(context: context)
            scriptEntity.categoryOrder = category
            scriptEntity.orderNumber = Int32(num)
        }
        
        do {
            try context.save()
            print("Category order saved to Core Data")
        } catch {
            print("Error saving category order to Core Data: \(error)")
        }
    }
}
