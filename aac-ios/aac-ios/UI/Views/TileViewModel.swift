//
//  TileViewModel.swift
//  aac-ios
//
//  Created by Jonathan Novecio on 3/14/24.
//

import Foundation
import CoreData


class TileViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var tiles: [Tile] = []
    @Published var droppedTiles: [Tile] = []
    @Published var currentFolder: Tile? = nil
    
    init() {
        container = NSPersistentContainer(name: "AAC Core Data")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error Loading")
            }
        }
        var curr = fetchTile(name: "main")
        if (curr == nil) { // set up main folder
            let newTile = Tile(context: self.container.viewContext)
            newTile.name = "main"
            newTile.imagePath = nil
            newTile.type = "Folder"
            newTile.parent = nil
            saveData()
        }
        self.currentFolder = fetchTile(name: "main")!
        fetchTiles(parent: currentFolder!)
        fetchDroppedTiles()
    }
    
    func fetchTile(name: String) -> Tile? {
        let request : NSFetchRequest = {
            let request = Tile.fetchRequest()
            
            request.predicate = NSPredicate(format: "name == %@", name)
            
            return request
        }()
        
        var tiles: [Tile]
        do {
            tiles =  try container.viewContext.fetch(request)
            if (tiles.isEmpty) {return nil}
            return tiles[0]
        } catch let error {
            print("Error Fetching")
        }
        
       return nil
    }
    
    
    func fetchTiles(parent: Tile) {
        let request : NSFetchRequest = {
            let request = Tile.fetchRequest()
            
            request.predicate = NSPredicate(format: "parent == %@", parent)
            
            return request
        }()
        
        do {
            tiles = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching")
        }
    }
    
    func addTile(text: String, imagePath: String, type: String, parent: Tile) {
        let newTile = Tile(context: container.viewContext)
        newTile.id = UUID()
        newTile.name = text
        newTile.imagePath = imagePath
        newTile.type = type
        newTile.parent = parent
        saveData()
        fetchTiles(parent: parent)
    }
    
    func deleteTile(tile: Tile, parent: Tile) {
        container.viewContext.delete(tile)
        saveData()
        fetchTiles(parent: parent)
        print(self.tiles)
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error Saving")
            print(error)
        }
    }
    
    func fetchDroppedTiles() {
        let request: NSFetchRequest<Tile> = Tile.fetchRequest()
        request.predicate = NSPredicate(format: "isDropped == true")
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)] // Maintain order
        
        do {
            droppedTiles = try container.viewContext.fetch(request)
        } catch {
            print("Error Fetching Dropped Tiles: \(error)")
        }
    }
    
    func addTileToDroppedTiles(tile: Tile) {
        if !droppedTiles.contains(where: { $0.id == tile.id }) && droppedTiles.count < 4 {
            tile.isDropped = true
            tile.orderIndex = Int16(droppedTiles.count) // Assign orderIndex
            droppedTiles.append(tile)
            saveData()
        }
    }
    
    func removeTileFromDroppedTiles(tile: Tile) {
        if let index = droppedTiles.firstIndex(where: { $0.id == tile.id }) {
            droppedTiles.remove(at: index)
            tile.isDropped = false
            tile.orderIndex = -1
            saveData()
            // Update orderIndex for remaining tiles
            for (newIndex, remainingTile) in droppedTiles.enumerated() {
                remainingTile.orderIndex = Int16(newIndex)
            }
            saveData()
        }
    }
    
    func createPlaceholderTile() -> Tile {
        let placeholderTile = Tile(context: container.viewContext)
        placeholderTile.name = "Placeholder"
        placeholderTile.type = "Temporary"
        placeholderTile.imagePath = nil
        return placeholderTile
    }

}
