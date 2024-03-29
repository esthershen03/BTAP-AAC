//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//
import SwiftUI
//import SymbolPicker
import PhotosUI
import UIKit


struct GridData: Codable, Equatable {
    var id = UUID() //identifies each grid tile
    var imagePath: String //path to the pic used on the tile
    var label: String //label for the tile
    var GridList: [GridData] //stores grid items if they are nested
    var type: String //type of tile
    
    //checks to see if two tiles are "equal" by comparing the labels and pics
    static func ==(lhs: GridData, rhs: GridData) -> Bool {
        return lhs.label == rhs.label && lhs.imagePath == rhs.imagePath
    }
    
    //loads the image for the tile
    var image: Image? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! //accesses the directory where all the image files are stored
        let fileURL = documentsDirectory.appendingPathComponent(imagePath) //makes the url to access the image
        //loads the pic if the url is valid and its found
        if let uiImage = UIImage(contentsOfFile: fileURL.path) {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
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

//saves the tiles as JSON objects in UserDefaults (needed for persistence)
func saveTiles(_ tiles: [GridData]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(tiles) {
        UserDefaults.standard.set(encoded, forKey: "SavedTiles")
    }
}

//loads the tiles from the UserDefaults (needed for persistence)
func loadTiles() -> [GridData] {
    if let savedTiles = UserDefaults.standard.object(forKey: "SavedTiles") as? Data {
        let decoder = JSONDecoder()
        if let loadedTiles = try? decoder.decode([GridData].self, from: savedTiles) {
            return loadedTiles
        }
    }
    return []
}

//view to display the grid
struct Build: View {
    @State private var data2: [GridData] = loadTiles() //array for the tiles displayed
    @State private var draggingItem: GridData? //tracks the item that is being moved (only if one is)
    @State private var addShowing = false //hides the add button
    
    var body: some View {
        VStack {
            if data2.isEmpty == false { //only display if there is data there
                ScrollView(.vertical) { //vertical scrolling
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], content: {
                        ForEach($data2.indices, id: \.self) { //loop to show all the data in the array as grid tiles
                            index in GridTile(labelText: data2[index].label, image: data2[index].image!, onClick: {
                                if (data2[index].type == "Folder") {
                                    data2 = data2[index].GridList
                                }
                            })
                            .onDrag {
                                self.draggingItem = data2[index] //sets the dragging item to the current index
                                return NSItemProvider() //apple default item provider for drag and drops
                            }
                            .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: $data2[index], data: $data2, draggedItem: $draggingItem))
                            .contextMenu {
                                Button(action: {
                                    data2.remove(at: index)
                                    saveTiles(data2) //modifies the indexes of the tiles and then resaves based on changes
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash") //lets you delete the tile on long press
                                }
                            }
                        }
                    })
                    .padding()
                }
            } else {
                Text("No tiles to display.").padding() //if there are no tiles to display, show that message
            }
            
            //
            Button(action: { addShowing.toggle()}) { //button to add a new tile
                Text("Add New Tile")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $addShowing) {
                BuildPopupView(visible: $addShowing, data: $data2) //shows the menu for adding a tile
            }
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
            guard let draggedItem = draggedItem else { return } //make sure there is a dragged item
            if let fromIndex = data.firstIndex(where: { $0.id == draggedItem.id }), let toIndex = data.firstIndex(where: { $0.id == destinationItem.id }) { //finds indices of the 'from' and 'to' tiles
                if fromIndex != toIndex {
                    withAnimation {
                        data.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex) //moves the tiles from the 'from' to the 'to' index
                        saveTiles(data) //saves the new positions of the tiles
                    }
                }
            }
        }
}

//adding new tiles popup
struct BuildPopupView: View {
    @Binding var visible: Bool //is the popup visible
    @Binding var data: [GridData]
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
                        Image(systemName: "photo.badge.plus")
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
                    let newTile = GridData(imagePath: imagePath, label: labelText, GridList: [], type: type)
                    data.append(newTile)
                    saveTiles(data) //adds and saves the new tile
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
