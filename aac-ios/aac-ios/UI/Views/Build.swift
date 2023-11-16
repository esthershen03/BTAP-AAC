//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI
import SymbolPicker

struct Build: View {
    @State private var data2: [(String,String)] = Array()
    
    @State private var data: [String] = Array(1...20).map( {String($0)} )
    @State private var draggingItem: String?
    @State private var showingAddPopup = false
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        if (!data2.isEmpty) {
            VStack() {
                ScrollView(.vertical) {
                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                        ForEach(data2.indices, id: \.self) { index in
                            let tuple = data2[index]
                            GridTile(labelText: tuple.1, image: tuple.0)
                                .onDrag {
                                    self.draggingItem = tuple.1
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: tuple.1, data: $data, draggedItem: $draggingItem)
                                )
                        }
                    }
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
                        BuildPopupView(isPresented: $showingAddPopup, data: $data2)
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
                    BuildPopupView(isPresented: $showingAddPopup, data: $data2)
                }
            }
        }
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

struct BuildPopupView: View {
    @Binding var isPresented: Bool
    @Binding var data: [(String,String)]
    
    @State private var iconPickerPresented = false
    @State private var icon = "pencil"
    @State private var textValue: String = ""
    
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
                        
                        Button {
                            iconPickerPresented = true
                        } label: {
                            HStack {
                                Image(systemName: icon)
                                    .font(.system(size: 50))
                                    .foregroundColor(.black)
                            }
                        }
                        .sheet(isPresented: $iconPickerPresented) {
                            SymbolPicker(symbol: $icon)
                        }
                        .padding()
                        
                        Spacer()
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
                }
                .frame(width: 400)
                
                GridTile(labelText: textValue, image: icon)
                
            }
            
            Button(action: {
                isPresented = false
                data.append((icon,textValue))
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
