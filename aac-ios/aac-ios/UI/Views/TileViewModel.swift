//
//  TileViewModel.swift
//  aac-ios
//
//  Created by Jonathan Novecio on 3/14/24.
//

import Foundation
import CoreData


class TileViewModel: ObservableObject {
    
    @Published var tiles: [Tile] = []
    @Published var droppedTiles: [Tile] = []
    @Published var currentFolder: Tile? = nil
    private let context = PersistenceController.shared.container.viewContext
    
    init() {
        var curr = fetchTile(name: "main")
        if (curr == nil) { // set up main folder
            let newTile = Tile(context: self.context)
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
        let request : NSFetchRequest = {
            let request = Tile.fetchRequest()
            
            request.predicate = NSPredicate(format: "name == %@", name)
            
            return request
        }()
        
        var tiles: [Tile]
        do {
            tiles =  try context.fetch(request)
            if (tiles.isEmpty) {return nil}
            return tiles[0]
        } catch let error {
            print("Error Fetching")
        }
        
       return nil
    }
    
    
    func fetchTiles(parent: Tile) {
        let request: NSFetchRequest<Tile> = {
            let request = Tile.fetchRequest()
            request.predicate = NSPredicate(format: "parent == %@", parent)
            return request
        }()
        
        do {
            tiles = try context.fetch(request)
        } catch {
            print("Error Fetching: \(error)")
        }
    }
    
    func addTile(text: String, imagePath: String, type: String, parent: Tile) {
        let newTile = Tile(context: context)
        newTile.id = UUID()
        newTile.name = text
        newTile.imagePath = imagePath
        newTile.type = type
        newTile.parent = parent
        saveData()
        fetchTiles(parent: parent)
    }
    
    func deleteTile(tile: Tile, parent: Tile) {
        context.delete(tile)
        saveData()
        fetchTiles(parent: parent)
    }
    
    func saveData() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error Saving: \(error), \(error.userInfo)")
            }
        }
    }
}
