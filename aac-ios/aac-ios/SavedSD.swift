//
//  SavedSD.swift
//  aac-ios
//
//  Created by Vamsi Putti on 11/9/24.
//

import Foundation
import CoreData
import SwiftUI

struct SavedSD: Hashable {
    var imageData: UIImage = UIImage()
    var name: String = ""
    var texts: [String] = []
    
    // Save to CoreData
    func saveToCoreData(context: NSManagedObjectContext) {
        let entity = SavedSceneDisplay(context: context)
        entity.imageData = imageData.pngData()
        entity.name = name
        entity.texts = texts as NSObject
        
        do {
            try context.save()
            print("Completed")
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    // Fetch all saved objects from CoreData
    static func fetchAll(from context: NSManagedObjectContext) -> [SavedSD] {
        let fetchRequest: NSFetchRequest<SavedSceneDisplay> = SavedSceneDisplay.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { entity in
                guard let data = entity.imageData, let image = UIImage(data: data) else { return SavedSD() }
                return SavedSD(imageData: image, name: entity.name ?? "", texts: entity.texts as? [String] ?? [])
            }
        } catch {
            print("Failed to fetch: \(error)")
            return []
        }
    }
    
    // Delete from CoreData
    func deleteFromCoreData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<SavedSceneDisplay> = SavedSceneDisplay.fetchRequest()
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
