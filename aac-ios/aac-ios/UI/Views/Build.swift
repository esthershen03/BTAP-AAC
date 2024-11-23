//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//
import SwiftUI
import PhotosUI
import CoreData

// Default Layout
struct Build: View {
    @StateObject var vm = TileViewModel()
    @State private var draggingItem: Tile?
    @State private var addShowing = false // Hides the add button

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        VStack {
            if (vm.currentFolder?.parent != nil) {
                HStack {
                    // Back button
                    Button(action: {
                        if let currentFolder = vm.currentFolder?.parent {
                            vm.currentFolder = currentFolder
                            vm.fetchTiles(parent: vm.currentFolder!)
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding([.top, .leading], 16)
                        }
                        .foregroundColor(.black)
                    }
                    Spacer()
                }
            }
            if (!vm.tiles.isEmpty) {
                ScrollView(.vertical) {
                    LazyVGrid(columns: adaptiveColumns, content: {
                        ForEach(vm.tiles) { tile in
                            GridTile(
                                labelText: tile.name ?? "none",
                                image: getImageFromImagePath(tile.imagePath ?? "") ?? Image(systemName: "questionmark.app"),
                                tileType: tile.type ?? "",
                                onRemove: {},
                                onClick: {
                                    if (tile.type == "Folder") {
                                        vm.currentFolder = tile
                                        vm.fetchTiles(parent: vm.currentFolder!)
                                    }
                                }
                            )
                            .onDrag {
                                self.draggingItem = tile
                                return NSItemProvider()
                            }
                            .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: tile, data: $vm.tiles, draggedItem: $draggingItem, droppedTiles: $vm.droppedTiles, vm: vm))
                            .contextMenu {
                                Button(action: {
                                    vm.deleteTile(tile: tile, parent: vm.currentFolder!)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    })
                }
                .padding(.top, vm.currentFolder?.parent == nil ? 16 : 0)
                .padding([.leading, .trailing, .bottom], 16)
            } else {
                VStack {
                    Spacer()
                    Text("No tiles to display.")
                        .font(.title)
                        .padding()
                    Spacer()
                }
            }
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("AACBlue"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 170)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.vertical, 16)
                        .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: vm.createPlaceholderTile(), data: $vm.tiles, draggedItem: $draggingItem, droppedTiles: $vm.droppedTiles, vm: vm))
                    Spacer()
                    HStack {
                        ForEach(vm.droppedTiles.indices, id: \.self) { index in
                            GridTile(
                                labelText: vm.droppedTiles[index].name ?? "none",
                                image: getImageFromImagePath(vm.droppedTiles[index].imagePath ?? "") ?? Image(systemName: "questionmark.app"),
                                tileType: "DroppedTile",
                                onRemove: {
                                    vm.removeTileFromDroppedTiles(tile: vm.droppedTiles[index]) // Remove from Core Data
                                },
                                onClick: {}
                            )
                            .frame(width: 100, height: 100) // Adjust size if needed
                        }
                        .padding(.horizontal, 30)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.trailing, 40)
                Button(action: { addShowing.toggle() }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("AACBlue"))
                            .frame(width: 170, height: 170)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.vertical, 16)
                        
                        Image(systemName: "pencil")
                            .resizable()
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    }
                }
                .sheet(isPresented: $addShowing) {
                    BuildPopupView(visible: $addShowing, vm: vm, currentFolder: vm.currentFolder!)
                }
            }
            .padding(.horizontal, 54)
        }
        .navigationBarHidden(true)
    }
}

func getImageFromImagePath(_ imagePath: String) -> Image? {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Accesses the directory where all the image files are stored
    let fileURL = documentsDirectory.appendingPathComponent(imagePath) // Makes the URL to access the image
    // Loads the pic if the URL is valid and it's found
    if let uiImage = UIImage(contentsOfFile: fileURL.path) {
        return Image(uiImage: uiImage)
    } else {
        return nil
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


// Dropping Mechanism
struct DropViewDelegate: DropDelegate {
    var destinationItem: Tile
    @Binding var data: [Tile]
    @Binding var draggedItem: Tile?
    @Binding var droppedTiles: [Tile]
    var vm: TileViewModel // Add vm for Core Data persistence

    func performDrop(info: DropInfo) -> Bool {
        if let draggedItem = draggedItem {
            if droppedTiles.count < 4 {
                vm.addTileToDroppedTiles(tile: draggedItem)
                self.draggedItem = nil
                return true
            }
        }
        return false
    }
}

// BuildPopupView remains unchanged
struct BuildPopupView: View {
    @Binding var visible: Bool
    var vm: TileViewModel
    @State var currentFolder: Tile
    @State private var labelText: String = ""
    @State private var iconItem: PhotosPickerItem?
    @State private var iconImage: Image?
    @State private var imagePath: String = ""
    @State private var type: String = "Tiles"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { visible = false }) {
                    Image(systemName: "x.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                }
                .foregroundColor(.black)
                .frame(width: 100, height: 100)
            }
            Text("Add a New Tile")
                .font(.system(size: 50))
            TilePreview(labelText: labelText, image: iconImage)
                .frame(width: 120, height: 150)
                .padding()
            Spacer(minLength: 20)
            VStack {
                HStack {
                    Text("Set Icon: ")
                        .font(.system(size: 40))
                    PhotosPicker(selection: $iconItem, matching: .images) {
                        Image(systemName: "photo")
                            .font(.system(size: 50))
                            .foregroundColor(.black)
                    }.padding()
                }
                .onChange(of: iconItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.iconImage = Image(uiImage: uiImage)
                            }
                            if let savedPath = saveImageToDocumentDirectory(uiImage) {
                                self.imagePath = savedPath
                            }
                        }
                    }
                }
                HStack {
                    Text("Set Label: ")
                        .font(.system(size: 40))
                    TextField("Tile label", text: $labelText)
                        .font(.title)
                        .frame(width: 150, height: 20)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.black), lineWidth: 1))
                        .padding()
                }
                HStack {
                    Text("Set Type:  ")
                        .font(.system(size: 40))
                    Picker("Type", selection: $type) {
                        Text("Tile").tag("Tile")
                        Text("Folder").tag("Folder")
                    }
                    .scaleEffect(2.5)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: 400)
                if iconImage != nil && !labelText.isEmpty {
                    Button(action: {
                        visible = false
                        vm.addTile(text: labelText, imagePath: imagePath, type: type, parent: self.currentFolder)
                    }) {
                        Text("Add Tile")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            .frame(minWidth: 0, maxWidth: 200)
                            .background(Color("AACBlue"))
                            .cornerRadius(10)
                    }
                    .padding()
                }
                Spacer(minLength: 20)
            }
        }
    }
}

// TilePreview remains unchanged
struct TilePreview: View {
    let labelText: String
    let image: Image?
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 140, height: 80)
                    .cornerRadius(10)
                    .padding(16)
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .clipped()
                        .padding(.top, 16)
                }
            }
            Text(labelText)
                .font(.system(size: 32))
                .foregroundColor(.black)
                .frame(width: 120)
                .frame(height: 40)
                .cornerRadius(8)
                .padding(10)
        }
        .padding(5)
        .background(Color("AACGrey"))
        .cornerRadius(12)
    }
}
