//
//  TileViewModel.swift
//  aac-ios
//
//  Created by Jonathan Novecio on 3/14/24.
//

import Foundation
import Firebase


class TileViewModel: ObservableObject {
    
    @Published var tiles: [GridTile] = []
    @Published var droppedTiles: [Tile] = []
    @Published var currentFolder: Tile? = nil
    
    private var ref: DatabaseReference = Database.database().reference()
    
    init() {
        fetchTiles() 
    }
    
    func fetchTiles() {
        guard let currentFolderID = currentFolder?.id else { return }
        
        ref.child("tiles").child(currentFolderID).observe(.value) { snapshot in
            var fetchedTiles: [GridTile] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let value = childSnapshot.value as? [String: Any],
                   let id = value["id"] as? String,
                   let name = value["name"] as? String,
                   let imagePath = value["imagePath"] as? String,
                   let type = value["type"] as? String {

                    let image = Image(uiImage: UIImage(named: imagePath) ?? UIImage())
                    
                    let gridTile = GridTile(
                        id: id,
                        labelText: name,
                        image: Image(imagePath), // Ensure the image can be loaded properly
                        tileType: type,
                        onRemove: {
                            self.deleteTile(tileID: id)
                        }
                    )
                    fetchedTiles.append(gridTile)
                }
            }
            self.tiles = fetchedTiles
        }
    }
    
    
    func addTile(text: String, imagePath: String, type: String, parent: Tile) {
        let newTileData = [
            "id": UUID().uuidString,
            "name": text,
            "imagePath": imagePath,
            "type": type
        ] as [String : Any]
        
        ref.child("tiles").child(newTileData["id"] as! String).setValue(newTileData) { error, _ in
            if let error = error {
                print("Error adding tile: \(error.localizedDescription)")
            } else {
                print("Tile added successfully.")
                self.fetchTiles() // Refresh the tile list after adding
            }
        }
    }
    
    func deleteTile(tileID: String) {
       ref.child("tiles/\(tileID)").removeValue { error, _ in
            if let error = error {
                print("Error deleting tile: \(error.localizedDescription)")
            } else {
                print("Tile deleted successfully.")
                self.fetchTiles() // Refresh the tile list after deletion
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = TileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(viewModel.tiles, id: \.id) { tile in
                    tile // Use the GridTile view directly here
                }
            }
            .navigationTitle("Tiles")
        }
    }
}
