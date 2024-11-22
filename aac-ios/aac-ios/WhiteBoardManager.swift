//
//  WhiteBoardManager.swift
//  aac-ios
//
//  Created by Hartej Singh on 11/18/24.
//

import CoreData
import SwiftUI

class WhiteBoardManager {
    static let shared = WhiteBoardManager()

    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveWhiteBoard(name: String, drawingImage: UIImage) {
        let whiteBoardEntity = WhiteBoardEntity(context: context)
        whiteBoardEntity.name = name
        whiteBoardEntity.drawingData = drawingImage.pngData() // Convert UIImage to Data

        do {
            try context.save()
            print("Saved Whiteboard")
        } catch {
            print("Failed to save whiteboard: \(error.localizedDescription)")
        }
    }

    func fetchWhiteBoards() -> [WhiteBoardEntity] {
        let fetchRequest: NSFetchRequest<WhiteBoardEntity> = WhiteBoardEntity.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch whiteboards: \(error.localizedDescription)")
            return []
        }
    }
}
