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

let tileOrderKey = "tileOrder"

struct Build: View {
    @State private var data2: [GridData] = Array()
    @State private var draggingItem: GridData?
    @State private var showingAddPopup = false
    @State private var data: [String] = {
        UserDefaults.standard.stringArray(forKey: tileOrderKey) ?? Array(1...20).map { String($0) }
    }()
    @State private var draggingItem2: String?
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        if (!$data2.isEmpty) {
            VStack() {
                ScrollView(.vertical) {
                    LazyVGrid(columns: adaptiveColumns, content: {
                        ForEach($data2, id: \.text ) {tuple in
                            GridTile(labelText: tuple.wrappedValue.text, image: tuple.wrappedValue.image, onClick: {
                                if (tuple.wrappedValue.type == "Folder") {
                                    data2 = tuple.wrappedValue.GridList
                                }
                            })
                                .onDrag {
                                    self.draggingItem = tuple.wrappedValue
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: tuple, data: $data2, draggedItem: $draggingItem))
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
                        .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: number, data: $data, draggedItem: $draggingItem2))
                }
            }
        }
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
        if let draggedItem, let fromIndex = data.firstIndex(of: draggedItem), let toIndex = data.firstIndex(of: destinationItem), fromIndex != toIndex {
            withAnimation {
                data.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                UserDefaults.standard.set(data, forKey: tileOrderKey)
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
            
            Button(action: {
                isPresented = false
                data.append(GridData(image: avatarImage!, text: textValue, GridList: [GridData](), type: type))
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
