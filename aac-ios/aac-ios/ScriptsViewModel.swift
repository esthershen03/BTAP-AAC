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
    private let key = "scripts"
    private let key2 = "scriptOrder"

    private let context = PersistenceController.shared.container.viewContext

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
                print("Error decoding scripts data: \(error)")
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
    
    func saveImage(categoryName: String, image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1.0)
        let newImage = CategoryImage(context: context)
        newImage.categoryName = categoryName
        newImage.imageData = imageData

        do {
            try context.save()
        } catch {
            print("Failed to save image: \(error)")
        }
    }
    
    func loadImage(for categoryName: String) -> UIImage? {
        let fetchRequest: NSFetchRequest<CategoryImage> = CategoryImage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", categoryName)

        do {
            let result = try context.fetch(fetchRequest)
            if let categoryImage = result.first, let imageData = categoryImage.imageData {
                return UIImage(data: imageData)
            }
        } catch {
            print("Failed to fetch image: \(error)")
        }
        return nil
    }
}
