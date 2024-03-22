//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI
import SymbolPicker
import PhotosUI

struct GridData: Equatable {
    var image: Image
    var text: String
    var GridList: [GridData]
    var type: String
    
    static func ==(lhs: GridData, rhs: GridData) -> Bool {
        return lhs.text == rhs.text
    }
}

struct Build: View {
    @State private var data2: [GridData] = Array()
    @State private var draggingItem: GridData?
    @State private var showingAddPopup = false
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        VStack {
            if !$data2.isEmpty {
                ScrollView(.vertical) {
                    LazyVGrid(columns: adaptiveColumns, content: {
                        ForEach($data2.indices, id: \.self) { index in
                            GridTile(labelText: data2[index].text, image: data2[index].image, onClick: {
                                if (data2[index].type == "Folder") {
                                    data2 = data2[index].GridList
                                }
                            })
                            .onDrag {
                                self.draggingItem = data2[index]
                                return NSItemProvider()
                            }
                            .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: $data2[index], data: $data2, draggedItem: $draggingItem))
                            .contextMenu {
                                Button(action: {
                                    data2.remove(at: index)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    })
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                .padding(.bottom, -21)
                .padding(.top)
            } else {
                Text("No tiles to display.")
                    .padding()
            }
            
            Button(action: {
                showingAddPopup.toggle()
            }) {
                Text("Add New Tile")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showingAddPopup) {
                BuildPopupView(isPresented: $showingAddPopup, data: $data2)
            }
            .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}


struct DropViewDelegate: DropDelegate {
    
    @Binding var destinationItem: GridData
    @Binding var data: [GridData]
    @Binding var draggedItem: GridData?
    
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
    @Binding var data: [GridData]
    
    @State private var iconPickerPresented = false
    @State private var textValue: String = ""
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var type: String = "Tiles"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .trailing])
            Text("Add a New Tile")
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
                            if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
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
            if avatarImage != nil && !textValue.isEmpty {
                Button(action: {
                    isPresented = false
                    data.append(GridData(image: avatarImage!, text: textValue, GridList: [GridData](), type: type))
                }) {
                    Text("Add Tile")
                        .font(.system(size: 20))
                        .foregroundColor(.white) // Text color white
                        .padding()
                        .frame(minWidth: 0, maxWidth: 200)
                        .background(Color.green) // Background color green
                        .cornerRadius(20)
                }
                .padding()
    
            }
            
            Spacer()
        }
        .frame(width: .infinity, height: .infinity)
    }
}
