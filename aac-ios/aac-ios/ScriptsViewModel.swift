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
    private let keyImages = "scriptsImages"


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
    
    func saveImages(_ categoryImages: [String: String]) {
        do {
            let data = try JSONEncoder().encode(categoryImages)
            UserDefaults.standard.set(data, forKey: keyImages)
        } catch {
            print("Error encoding images data: \(error)")
        }
    }
    
    func loadImages() -> [String: String] {
        if let data = UserDefaults.standard.data(forKey: keyImages) {
            do {
                return try JSONDecoder().decode([String: String].self, from: data)
            } catch {
                print("Error decoding images data: \(error)")
            }
        }
        return [:] // Return an empty dictionary if no data is found
    }

}
