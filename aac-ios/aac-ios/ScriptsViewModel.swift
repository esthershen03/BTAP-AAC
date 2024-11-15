//
//  ScriptsViewModel.swift
//  aac-ios
//
//  Created by Asma on 4/17/24.
//

import Foundation

class ScriptsViewModel: ObservableObject {
    private let key = "scripts"
    private let key2 = "scriptOrder"
    private let imageKey = "categoryImages"

    @Published var lastModified: Date?

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
            let imageDataDict = try categoryImages.mapValues { image in
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

    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.removeObject(forKey: key2)
        UserDefaults.standard.removeObject(forKey: imageKey)
        lastModified = Date()
        print("All data cleared.")
    }
}
