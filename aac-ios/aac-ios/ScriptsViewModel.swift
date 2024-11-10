//
//  ScriptsViewModel.swift
//  aac-ios
//
//  Created by Asma on 4/17/24.
//

import Foundation
import CoreData
import SwiftUI

class ScriptsViewModel: ObservableObject {
    private let context = PersistenceController.shared.context

    func saveScripts(_ categoryTexts: [String: [String]]?) {
        guard let categoryTexts = categoryTexts else {
            clearScriptsData()
            return
        }

        clearScriptsData()
        
        for (categoryTitle, texts) in categoryTexts {
            let category = Category(context: context)
            category.title = categoryTitle

            for text in texts {
                let script = Script(context: context)
                script.text = text
                script.category = category
            }
        }

        saveContext()
    }

    func loadScripts() -> [String: [String]]? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            var categoryTexts: [String: [String]] = [:]
            
            for category in categories {
                if let title = category.title {
                    let scripts = category.scripts?.compactMap { ($0 as? Script)?.text } ?? []
                    categoryTexts[title] = scripts
                }
            }
            
            return categoryTexts
        } catch {
            print("Error decoding scripts data: \(error)")
            return nil
        }
    }
    
    func saveOrder(_ categoryOrder: [Int: String]?) {
        guard let categoryOrder = categoryOrder else {
            clearOrderData()
            return
        }
        
        clearOrderData()
        
        for (order, categoryTitle) in categoryOrder {
            let category = Category(context: context)
            category.title = categoryTitle
            category.order = Int16(order)
        }
        
        saveContext()
    }
    
    func loadOrder() -> [Int: String]? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            var categoryOrder: [Int: String] = [:]
            
            for category in categories {
                if let title = category.title {
                    categoryOrder[Int(category.order)] = title
                }
            }
            
            return categoryOrder
        } catch {
            print("Error decoding script order data: \(error)")
            return nil
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    private func clearScriptsData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error clearing scripts data: \(error)")
        }
    }

    private func clearOrderData() {
        clearScriptsData()
    }
}
