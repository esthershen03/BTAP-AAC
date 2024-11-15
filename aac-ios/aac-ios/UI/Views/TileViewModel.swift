//
//  TileViewModel.swift
//  aac-ios
//
//  Created by Jonathan Novecio on 3/14/24.
//

import Foundation
import CoreData
import SwiftUI


class TileViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var tiles: [Tile] = []
    @Published var droppedTiles: [Tile] = []
    @Published var currentFolder: Tile? = nil

    @Environment(\.managedObjectContext) private var viewContext

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
    }
    
    func fetchTile(name: String) -> Tile? {
        let request : NSFetchRequest<Tile> = Tile.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        var tiles: [Tile]
        do {
            tiles = try container.viewContext.fetch(request)
            if (tiles.isEmpty) { return nil }
            return tiles[0]
        } catch let error {
            print("Error Fetching Tile: \(error)")
        }
        return nil
    }
    
    
    func fetchTiles(parent: Tile) {
        let request: NSFetchRequest<Tile> = Tile.fetchRequest()
        request.predicate = NSPredicate(format: "parent == %@", parent)
        
        do {
            tiles = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching Tiles: \(error)")
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
    
    func fetchTilesFromPersistence() {
        let request: NSFetchRequest<Tile> = Tile.fetchRequest()
        
        do {
            let fetchedTiles = try container.viewContext.fetch(request)
            tiles = fetchedTiles
        } catch let error {
            print("Error Fetching Tiles from Persistence: \(error)")
        }
    }
    func addToDroppedTiles(tile: Tile) {
        droppedTiles.append(tile)
    }
    func removeFromDroppedTiles(tile: Tile) {
        droppedTiles.removeAll { $0.id == tile.id }
    }
}
