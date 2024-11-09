//
//  SceneDisplayViewModel.swift
//  aac-ios
//
//  Created by Vamsi Putti on 11/9/24.
//

import Foundation
import CoreData

class SceneDisplayViewModel : ObservableObject {
    
    let container = NSPersistentContainer(name: "Model")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
}
