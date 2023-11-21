//
//  Scripts.swift
//  aac-ios
//
//  Created by Emily Wu on 10/4/23.
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
    @State private var selectedTile: ScriptTile?
    @State private var showPopover = false
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 40) {
            ForEach(tiles, id: \.label) { tile in
                Button(action: {
                    selectedTile = tile
                    showPopover.toggle()
                }) {
                    GridTile(labelText: tile.label, image: tile.image)
                }
                .popover(isPresented: Binding(
                    get: { showPopover },
                    set: { _ in }
                ), content: {
                    PopoverView(selectedTile: $selectedTile, sentences: selectedTile?.sentences)
                })
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
        let sentences = ["Script Sentence 1", "Script Sentence 2", "Script Sentence 3"]
        for label in labels {
            let tile = ScriptTile(label: label, image: "eye", sentences: sentences)
            result.append(tile)
        }
        return result
    }
}

struct PopoverView: View {
    @Binding var selectedTile: ScriptTile?
    let sentences: [String]?
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.black)
                .imageScale(.large)
        }
        .padding()
    }
}


struct Scripts_Previews: PreviewProvider {
    static var previews: some View {
        Scripts()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
