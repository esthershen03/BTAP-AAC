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
            newTile.image = nil
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
    
    func addTile(text: String, image: Data?, type: String, parent: Tile) {
        let newTile = Tile(context: container.viewContext)
        newTile.name = text
        newTile.image = image
        newTile.type = type
        newTile.parent = parent
        saveData()
        fetchTiles(parent: parent)
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error Saving")
            print(error)
        }
    }
}
