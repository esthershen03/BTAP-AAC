//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//
import SwiftUI
import SymbolPicker
import PhotosUI
import UIKit

struct GridData: Codable, Equatable {
    var id = UUID()
    var imagePath: String
    var text: String
    var GridList: [GridData]
    var type: String
    
    static func ==(lhs: GridData, rhs: GridData) -> Bool {
        return lhs.text == rhs.text && lhs.imagePath == rhs.imagePath
    }
    
    var image: Image {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imagePath)
        if let uiImage = UIImage(contentsOfFile: fileURL.path) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "photo")
        }
    }
}

struct Build: View {
    @State private var data2: [GridData] = loadTiles()
    @State private var draggingItem: GridData?
    @State private var showingAddPopup = false
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        VStack {
            if !data2.isEmpty {
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
                                    saveTiles(data2)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    })
                    .padding()
                }
            } else {
                Text("No tiles to display.").padding()
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
        }
        .navigationBarHidden(true)
        .onAppear {
            self.data2 = loadTiles()
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
            guard let draggedItem = draggedItem else { return }
            if let fromIndex = data.firstIndex(where: { $0.id == draggedItem.id }),
               let toIndex = data.firstIndex(where: { $0.id == destinationItem.id }) {
                if fromIndex != toIndex {
                    withAnimation {
                        data.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                        saveTiles(data)
                    }
                }
            }
        }
}

struct BuildPopupView: View {
    @Binding var isPresented: Bool
    @Binding var data: [GridData]
    
    @State private var textValue: String = ""
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var imagePath: String = ""
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
            
            if !textValue.isEmpty || avatarImage != nil {
                Text("Preview")
                    .font(.headline)
                    .padding(.top)

                TilePreview(labelText: textValue, image: avatarImage)
                    .frame(width: 120, height: 150)
                    .padding()
            }

            Text("Add a New Tile")
                .padding()
                .font(.system(size: 36))

            VStack {
                HStack {
                    Text("Set icon: ")
                        .font(.system(size: 36))
                    PhotosPicker(selection: $avatarItem, matching: .images) {
                        Image(systemName: "pencil")
                            .font(.system(size: 24))
                    }
                    .padding()
                    
                    Spacer()
                }
                .onChange(of: avatarItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.avatarImage = Image(uiImage: uiImage)
                            }
                            if let savedPath = saveImageToDocumentDirectory(uiImage) {
                                self.imagePath = savedPath
                            }
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
                    .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                }
            }
            .frame(maxWidth: 400)
            
            if avatarImage != nil && !textValue.isEmpty {
                Button(action: {
                    isPresented = false
                    let newTile = GridData(imagePath: imagePath, text: textValue, GridList: [], type: type)
                    data.append(newTile)
                    saveTiles(data)
                }) {
                    Text("Add Tile")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: 200)
                        .background(Color.green)
                        .cornerRadius(20)
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}


func saveImageToDocumentDirectory(_ image: UIImage) -> String? {
    guard let data = image.jpegData(compressionQuality: 1) else { return nil }
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileName = UUID().uuidString + ".jpeg"
    let fileURL = documentDirectory.appendingPathComponent(fileName)
    
    do {
        try data.write(to: fileURL)
        return fileName
    } catch {
        print("Error saving image: \(error)")
        return nil
    }
}

func saveTiles(_ tiles: [GridData]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(tiles) {
        UserDefaults.standard.set(encoded, forKey: "SavedTiles")
    }
}

func loadTiles() -> [GridData] {
    if let savedTiles = UserDefaults.standard.object(forKey: "SavedTiles") as? Data {
        let decoder = JSONDecoder()
        if let loadedTiles = try? decoder.decode([GridData].self, from: savedTiles) {
            return loadedTiles
        }
    }
    return []
}

struct TilePreview: View {
    let labelText: String
    let image: Image?

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 90, height: 90)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 8)
                    )
                    .cornerRadius(10)
                    .padding(.top, 16)
                
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .clipped()
                        .padding(.top, 16)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(.systemGray4))
                        .padding(.top, 16)
                }
            }
            
            Text(labelText)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
        }
        .padding(5)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}