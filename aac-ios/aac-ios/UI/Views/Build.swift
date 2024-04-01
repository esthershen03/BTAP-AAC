//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI
import PhotosUI
import CoreData

// default layout
struct Build: View {
    @StateObject var vm = TileViewModel()
    
    @State private var draggingItem: Tile?
    @State private var showingAddPopup = false
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        if (vm.tiles.count > 0) {
            VStack() {
                ScrollView(.vertical) {
                    LazyVGrid(columns: adaptiveColumns, content: {
                        ForEach(vm.tiles) { tile in // get the tile that is the current folder (default: main)
                            GridTile(labelText: tile.name!, image: tile.image!,
                                     onClick: {
                                        if (tile.type == "Folder") {
                                            vm.currentFolder = tile
                                            vm.fetchTiles(parent: vm.currentFolder!)
                                        }
                                })
                                .onDrag {
                                    self.draggingItem = tile
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: tile, data: $vm.tiles, draggedItem: $draggingItem))
                        }
                    })
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                .padding(.bottom, -21)
                .padding(.top)
                .navigationBarHidden(true)
                
                HStack {
                    Spacer()
                    AddButton {
                        showingAddPopup.toggle()
                    }
                    .sheet(isPresented: $showingAddPopup) {
                        BuildPopupView(isPresented: $showingAddPopup, vm: vm, currentFolder: vm.currentFolder!)
                    }
                }
            }
        } else {
            VStack() {
                Text("Add a tile:")
                AddButton {
                    showingAddPopup.toggle()
                }
                .sheet(isPresented: $showingAddPopup) {
                    BuildPopupView(isPresented: $showingAddPopup, vm: vm, currentFolder: vm.currentFolder!)
                }
            }
        }
    }
}

// Dropping Mechanism
struct DropViewDelegate: DropDelegate {
    
    var destinationItem: Tile
    @Binding var data: [Tile]
    @Binding var draggedItem: Tile?
    
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

struct BuildPopupView: View {
    @Binding var isPresented: Bool
    var vm: TileViewModel
    
    @State private var iconPickerPresented = false
    @State private var textValue: String = ""
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Data?
    @State private var type: String = "Tiles"
    @State var currentFolder: Tile
    
    
    var body: some View {
        VStack {
            Text("Add a new tile")
                .padding()
                .font(.system(size: 36))
            
            HStack(spacing: 0) {
                
                VStack {
                    
                    HStack {
                        
                        Text("Set icon: ")
                            .font(.system(size: 36))
                        PhotosPicker(selection: $avatarItem, matching: .images) {
                            Image(systemName: "pencil")
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .onChange(of: avatarItem) { avatarItem in
                        Task {
                            if let loaded = try? await avatarItem?.loadTransferable(type: Data.self) {
                                avatarImage = loaded
                            } else {
                                print("Failed")
                            }
                        }
                    }
                    HStack {
                        
                        Text("Set label: ")
                            .font(.system(size: 36))
                        
                        TextField("Enter text", text: $textValue)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                        
                        Spacer()
                    }
                    HStack {
                        Text("Set type: ")
                            .font(.system(size: 36))
                        Picker("Types", selection: $type) {
                            Text("Folder").tag("Folder")
                            Text("Tiles").tag("Tiles")
                        }
                        Spacer()
                    }
                }
                .frame(width: 400)
                
                if (avatarImage != nil) {
                    GridTile(labelText: textValue, image: avatarImage!, onClick: {})
                }
                
            }
            
            Button(action: {
                isPresented = false
                vm.addTile(text: textValue, image: avatarImage!, type: type, parent: self.currentFolder)
            }) {
                Text("Save")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .padding()
                    .frame(minWidth: 0, maxWidth: 100)
                    .background(Color.green)
                    .cornerRadius(20)
            }
            .padding()
            
            Spacer()
        }
        .frame(width: .infinity, height: .infinity)
    }
}
