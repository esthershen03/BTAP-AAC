//
//  TileViewModel.swift
//  aac-ios
//
//  Created by Jonathan Novecio on 3/14/24.
//

import Foundation
import Firebase


class TileViewModel: ObservableObject {
    
    @Published var tiles: [Tile] = []
    @Published var droppedTiles: [Tile] = []
    @Published var currentFolder: Tile? = nil
    
    private var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
        fetchTiles()
    }
    
    func fetchTile() {
        guard let currentFolderID = currentFolder?.id else { return }
        
        ref.child("tiles").observe(.value) { snapshot in
            var fetchedTiles: [Tile] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let tile = Tile(snapshot: childSnapshot) {
                    fetchedTiles.append(tile)
                }
            }
            self.tiles = fetchedTiles
        }
    }
    
    
    func addTile(text: String, imagePath: String, type: String, parent: Tile) {
        let newTile = Tile(id: UUID().uuidString, name: text, imagePath: imagePath, type: type, parentID: parent.id!)
        let tileData = [
            "id": newTile.id!,
            "name": newTile.name,
            "imagePath": newTile.imagePath ?? "",
            "type": newTile.type,
            "parentID": newTile.parentID ?? ""
        ] as [String : Any]
        
        ref.child("tiles").child(parent.id!).child(newTile.id!).setValue(tileData) { error, _ in
            if let error = error {
                print("Error adding tile: \(error.localizedDescription)")
            } else {
                print("Tile added successfully.")
                self.fetchTiles() // Refresh the tile list after adding
            }
        }
    }
    
    func deleteTile(tile: Tile, parent: Tile) {
       ref.child("tiles").child(parent.id!).child(tile.id!).removeValue { error, _ in
            if let error = error {
                print("Error deleting tile: \(error.localizedDescription)")
            } else {
                print("Tile deleted successfully.")
                self.fetchTiles() // Refresh the tile list after deletion
            }
        }
    }
}
    // Assume the Tile class is modified to support Firebase
extension Tile {
    // This initializer assumes a Firebase snapshot
    convenience init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        let id = value["id"] as? String ?? ""
        let name = value["name"] as? String ?? ""
        let imagePath = value["imagePath"] as? String
        let type = value["type"] as? String ?? ""
        let parentID = value["parentID"] as? String
        
        self.init(id: id, name: name, imagePath: imagePath, type: type, parentID: parentID)
    }
}
