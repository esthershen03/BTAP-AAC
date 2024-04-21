//
//  ScriptsViewModel.swift
//  aac-ios
//
//  Created by Asma on 4/17/24.
//

import Foundation

class ScriptsViewModel: ObservableObject {
    private let key = "scripts"

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
}
