//
//  ScriptsViewModel.swift
//  aac-ios
//
//  Created by Asma on 4/17/24.
//

import Foundation
import CoreData
import UIKit



class ScriptsViewModel: ObservableObject {
    private let key = "scripts"
    private let key2 = "scriptOrder"
    private let imageKey = "categoryImages"
    @Published var scripts: [Scripts] = []
    private var context: NSManagedObjectContext
    
    private var lastModified: Date?

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchScripts()
    }

    func saveScripts(_ categoryTexts: [String: [String]]?) {
        guard let categoryTexts = categoryTexts else {
            UserDefaults.standard.set(nil, forKey: key)
            return
        }
        do {
            let data = try JSONEncoder().encode(categoryTexts)
            UserDefaults.standard.set(data, forKey: key)
            lastModified = Date()
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
                print("Error decoding scripts data: \(error)")
                return nil
            }
        }
        return nil
    }

    func saveImages(_ categoryImages: [String: UIImage]?) {
        guard let categoryImages = categoryImages else {
            UserDefaults.standard.set(nil, forKey: imageKey)
            return
        }
        do {
            let imageDataDict = categoryImages.mapValues { image in
                image.pngData() ?? Data()
            }
            let data = try JSONEncoder().encode(imageDataDict)
            UserDefaults.standard.set(data, forKey: imageKey)
            lastModified = Date()
        } catch {
            print("Error encoding images data: \(error)")
        }
    }

    func loadImages() -> [String: UIImage]? {
        if let data = UserDefaults.standard.data(forKey: imageKey) {
            do {
                let imageDataDict = try JSONDecoder().decode([String: Data].self, from: data)
                let images = imageDataDict.compactMapValues { data in
                    UIImage(data: data)
                }
                return images
            } catch {
                print("Error decoding images data: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func saveOrder(_ categoryOrder: [Int: String]?) {
        guard let categoryOrder = categoryOrder else {
            UserDefaults.standard.set(nil, forKey: key2)
            return
        }
        do {
            let data = try JSONEncoder().encode(categoryOrder)
            UserDefaults.standard.set(data, forKey: key2)
            lastModified = Date() 
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

    func fetchScripts() {
        let fetchRequest: NSFetchRequest<Scripts> = Scripts.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            self.scripts = results.map { Script(entity: $0) } // Assuming you have a Script model that can be initialized from ScriptEntity
        } catch {
            print("Failed to fetch scripts: \(error)")
        }
    }
}

struct SavedScript: Hashable {
    var imageData: Data? = nil
    var name: String = ""
    var texts: [String] = []

    // Save to CoreData
    func saveToCoreData(context: NSManagedObjectContext) {
        let entity = SavedScriptEntity(context: context)
        entity.imageData = imageData
        entity.name = name
        entity.texts = texts as NSObject

        do {
            try context.save()
            print("Script saved successfully")
        } catch {
            print("Failed to save: \(error)")
        }
    }

    static func fetchAll(from context: NSManagedObjectContext) -> [SavedScript] {
        let fetchRequest: NSFetchRequest<SavedScriptEntity> = SavedScriptEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { entity in
                guard let data = entity.imageData else { return SavedScript() }
                return SavedScript(imageData: data, name: entity.name ?? "", texts: entity.texts as? [String] ?? [])
            }
        } catch {
            print("Failed to fetch: \(error)")
            return []
        }
    }

    func deleteFromCoreData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<SavedScriptEntity> = SavedScriptEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
        } catch {
            print("Failed to delete: \(error)")
        }
    }
}
