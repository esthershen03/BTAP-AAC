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
    @State private var addShowing = false //hides the add button

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        VStack() {
            if (!vm.tiles.isEmpty) {
                ScrollView(.vertical) {
                    LazyVGrid(columns: adaptiveColumns, content: {
                        ForEach(vm.tiles) { tile in // get the tile that is the current folder (default: main)
                            GridTile(labelText: tile.name ?? "none", image: getImageFromImagePath(tile.imagePath ?? "") ?? Image(systemName: "questionmark.app"),
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
                .padding()
            } else {
                Text("No tiles to display.").padding() //if there are no tiles to display, show that message
            }
            HStack() {
                Button(action: { addShowing.toggle()}) { //button to add a new tile
                    Text("Add New Tile")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $addShowing) {
                    BuildPopupView(visible: $addShowing, vm: vm, currentFolder: vm.currentFolder!)
                }
                if (!vm.tiles.isEmpty) {
                    Button {
                        if (vm.currentFolder?.parent != nil) {
                            vm.currentFolder = vm.currentFolder?.parent
                            vm.fetchTiles(parent: vm.currentFolder!)
                        }
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

func getImageFromImagePath(_ imagePath: String) -> Image? {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! //accesses the directory where all the image files are stored
    let fileURL = documentsDirectory.appendingPathComponent(imagePath) //makes the url to access the image
    //loads the pic if the url is valid and its found
    if let uiImage = UIImage(contentsOfFile: fileURL.path) {
        return Image(uiImage: uiImage)
    } else {
        return nil
    }
}

//saves pictures to a document directory so that they can be saved and loaded (needed for persistence)
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
    @Binding var visible: Bool //is the popup visible
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
                Button(action: {visible = false}) { //button to x out of menu to add tile
                    Image(systemName: "xmark.circle.fill")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
            }
            Text("Add a New Tile")
                .padding()
                .font(.system(size: 36))
                .padding([.top, .trailing])
            
            //shows a preview of the tile before adding
            if !labelText.isEmpty || iconImage != nil {
                Text("Preview")
                    .font(.headline)
                    .padding(.top)
                TilePreview(labelText: labelText, image: iconImage)
                    .frame(width: 120, height: 150)
                    .padding()
            }
            //tile settings
            VStack {
                HStack {
                    Text("Set Icon: ")
                        .font(.system(size: 36))
                    PhotosPicker(selection: $iconItem, matching: .images) {
                        Image(systemName: "photo.artframe")
                            .font(.system(size: 36))
                    }
                    .padding()
                    Spacer()
                }
                //sets the new icon image for the tile
                .onChange(of: iconItem) { newItem in Task {
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
                //sets the label for the tile
                HStack {
                    Text("Set Label: ")
                        .font(.system(size: 36))
                    TextField("Enter tile label text", text: $labelText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                        .padding()
                    Spacer()
                }
                //sets type (folder or tile)
                HStack {
                    Text("Set Type: ")
                        .font(.system(size: 36))
                    Picker("Types", selection: $type) {
                        Text("Tile").tag("Tile") //default is tile
                        Text("Folder").tag("Folder")
                    }
                    .pickerStyle(MenuPickerStyle())
                    Spacer()
                }
            }
            .frame(maxWidth: 400)
            if iconImage != nil && !labelText.isEmpty { //doesnt allow you to add until fields are completed
                Button(action: {
                    visible = false
                    vm.addTile(text: labelText, imagePath: imagePath, type: type, parent: self.currentFolder) //adds and saves the new tile
                }) {
                    Text("Add Tile") //button to confirm tile adding
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: 200)
                        .background(Color.blue)
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

//tile preview (from add tile menu) configurations
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
    }
}
