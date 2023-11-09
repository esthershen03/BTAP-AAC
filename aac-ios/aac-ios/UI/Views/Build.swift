//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct Build: View {
    @State private var data: [String] = Array(1...20).map( {String($0)} )
    @State private var draggingItem: String?
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                ForEach(data, id: \.self) { number in
                    GridTile(labelText: number, image: "eye")
                        .onDrag {
                            self.draggingItem = number
                            return NSItemProvider()
                        }
                        .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: number, data: $data, draggedItem: $draggingItem)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .padding(.bottom, -21)
        .padding(.top)
        .navigationBarHidden(true)
    }
}

struct Build_Previews: PreviewProvider {
    static var previews: some View {
        Build()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

struct DropViewDelegate: DropDelegate {
    
    let destinationItem: String
    @Binding var data: [String]
    @Binding var draggedItem: String?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        // Swap Items
        if let draggedItem {
            let fromIndex = data.firstIndex(of: draggedItem)
            if let fromIndex {
                let toIndex = data.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.data.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}
