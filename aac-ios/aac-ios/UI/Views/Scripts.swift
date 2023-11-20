//
//  Scripts.swift
//  aac-ios
//
//  Created by Emily Wu on 10/04/23.
//

import SwiftUI
struct ScriptTile: Identifiable {
    var id: ObjectIdentifier?
    var label: String
    var image: String
    var sentences: [String]?
}

struct Scripts: View {
    let labels = ["Health", "Fitness", "Movies", "Sports",
                  "Travel", "Greetings", "Shopping", "Social", "Favors",
                  "Invites", "Music", "Aid", "Money", "Clothes",
                  "TV Shows", "Work"]
    
    @State private var tiles: [ScriptTile] = []
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 40) {
            ForEach(tiles, id: \.label) { tile in
                            GridTile(labelText: tile.label, image: tile.image)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, -21)
        .navigationBarHidden(true)
        .onAppear {
            self.tiles = self.createTiles()
        }
    }
    
    func createTiles() -> [ScriptTile] {
        var result: [ScriptTile] = []
        for label in labels {
            let tile = ScriptTile(label: label, image: "eye")
            result.append(tile)
        }
        return result
    }
}

struct Scripts_Previews: PreviewProvider {
    static var previews: some View {
        Scripts()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
