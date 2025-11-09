import SwiftUI
import PhotosUI
import Foundation
import AVFoundation

var categoryTexts: [String: [String]] = [:]
var categoryImages: [String : String] = [:]
let scriptsViewModel = ScriptsViewModel() // currently only saves category titles and scripts inside; needs to be modified to account for images also
var currScriptLabel = "hi"



var categoryOrder: [Int: String] = [:]
var orderNum = 1

func saveImageToDocumentDirectory2(_ image: UIImage) -> String? {
    guard let data = image.pngData() else { return nil }
    let fileName = UUID().uuidString + ".png"
    let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
    do {
        try data.write(to: filePath)
        return fileName // Return file name for persistence
    } catch {
        print("Failed to save image: \(error)")
        return nil
    }
}


func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}




struct Scripts: View {
    // Define your categories here
    @State private var addShowing = false
    @State private var categories: [String]
    @State private var showScriptText = false
    @State private var showError = false
    

    
    init() {
        if let savedScripts = scriptsViewModel.loadScripts() {
            categoryTexts = savedScripts
        }
        categoryOrder = scriptsViewModel.loadOrder() ?? [:]
        categoryImages = scriptsViewModel.loadImages()

        // Handle case where no saved scripts exist
        if categoryTexts.isEmpty {
            self._categories = State(initialValue: ["Health", "Food", "Activities", "TV"])

            // Use strings for default SF Symbols
            categoryImages = [
                "Health": "heart.text.clipboard.fill",
                "Food": "fork.knife",
                "Activities": "figure.run",
                "TV": "play.tv.fill"
            ]

            var num = 1
            for category in self._categories.wrappedValue {
                categoryTexts[category] = Array(repeating: "", count: 6)
                categoryOrder[num] = category
                num += 1
            }

            scriptsViewModel.saveScripts(categoryTexts)
            scriptsViewModel.saveOrder(categoryOrder)
            scriptsViewModel.saveImages(categoryImages)
        } else {
            // Populate categories based on saved order
            self._categories = State(initialValue: Array(categoryOrder.values))
        }
    }

    
    var body: some View {
        // Create a grid layout with 3 columns
        let columns = Array(repeating: GridItem(.fixed(200), spacing: 50), count: 4)

        VStack {
            
                Button(action: {
                    // When the button is clicked, add the new category
                    addShowing.toggle()
                    }
                ) {
                    Text("Add")
                        .frame(width: 900, height: 30)
                        .font(.system(size:32))
                        .padding()
                        .background(Color("AACBlue"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))

                }.sheet(isPresented: $addShowing) {
                    ScriptsMakePopUp(visible: $addShowing, categories: $categories)
                }
            

            ScrollView {
                LazyVGrid(columns: columns, spacing: 60) {
                    ForEach(categories, id: \.self) { category in
                        let imageToUse = categoryImages[category].flatMap { imagePath in
                            let fullPath = getDocumentsDirectory().appendingPathComponent(imagePath).path
                            return UIImage(contentsOfFile: fullPath).map { Image(uiImage: $0) }
                        } ?? Image(systemName: "rectangle") // Default fallback

                        ScriptsCategoryButton(
                            labelText: .constant(category),
                            image: imageToUse,
                            available: false,
                            imageColor: "red",
                            showScriptText: $showScriptText
                        )
                    }
                }
                .padding()
            }



            .padding(15)
            .sheet(isPresented: $showScriptText) {
                // This is the view that will be shown when showScriptText is true
                ScriptTextScreen(showScriptText: $showScriptText)
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("That category already exists!")
                )
            }
        } //end of vstck
        .onAppear{
            if let savedScripts = scriptsViewModel.loadScripts() {
                categoryTexts = savedScripts
                return
            }
            return
        }
    }
}

struct ToolbarCircleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .frame(width: 36, height: 36)
            .background(Color("AACGrey"))
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 1))
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .accessibilityAddTraits(.isButton)
    }
}

struct ScriptLineRow: View {
    @Binding var text: String
    let canDelete: Bool
    let onSpeak: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            TextField("Enter script here", text: $text, axis: .vertical)
                .font(.system(size: 24))
                .padding(.vertical, 10)
                .padding(.leading, 12)

            // trailing mini-toolbar
            HStack(spacing: 8) {
                Button(action: onSpeak) {
                    Image(systemName: "speaker.wave.2.fill")
                        .accessibilityLabel("Speak line")
                }
                .buttonStyle(ToolbarCircleStyle())

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .accessibilityLabel("Delete line")
                }
                .buttonStyle(ToolbarCircleStyle())
                .disabled(!canDelete)
                .opacity(canDelete ? 1 : 0.4)
            }
            .padding(6)
            .background(.thinMaterial, in: Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(text.isEmpty ? .white : Color("AACBlue"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}


struct ScriptTextScreen: View {
    @Binding var showScriptText: Bool
    @Environment(\.presentationMode) var presentationMode

    private let maxLines = 8
    private let minLines = 1
    let speechSynthesizer = AVSpeechSynthesizer()

    // Start from saved values for the current category.
    // Ensure at least 1 line and at most 8 on load.
    @State private var textValues: [String] =
        {
            let saved = categoryTexts[currScriptLabel] ?? [""]
            let nonEmpty = saved.isEmpty ? [""] : saved
            return Array(nonEmpty.prefix(8))
        }()

    @State private var searchText: String = ""   // (kept for parity with your original)

    var body: some View {
        VStack(spacing: 20) {
            // Header with title and quick actions
            HStack {
                Text(currScriptLabel)
                    .font(.system(size: 40))
                Spacer()
                // Add line button
                Button {
                    addLine()
                } label: {
                    Label("Add line", systemImage: "plus.circle.fill")
                        .font(.title2)
                }
                .disabled(textValues.count >= maxLines)

            }

            // Fields live in a ScrollView so the UI never overflows
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(textValues.indices), id: \.self) { index in
                        ScriptLineRow(
                            text: $textValues[index],
                            canDelete: textValues.count > minLines,
                            onSpeak: { speakText(text: textValues[index]) },
                            onDelete: { removeLine(at: index) }
                        )
        VStack(spacing:30) {
            Text(currScriptLabel)
                .font(.system(size: 40))
            Button(action: {
                Task {
                    isGenerating = true
                    do {
                        let generated = try await scriptGenerator.generateScripts(for: currScriptLabel)
                        textValues = generated.map { $0.text }
                        categoryTexts[currScriptLabel] = textValues
                        scriptsViewModel.saveScripts(categoryTexts)
                    } catch {
                        print("⚠️ Failed to generate scripts: \(error)")
                    }
                    isGenerating = false
                }
            }) {
                if isGenerating {
                    ProgressView("Generating scripts…")
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.system(size: 24))
                        .padding()
                } else {
                    Text("✨ Generate Scripts")
                        .font(.system(size: 28))
                        .frame(width: 280, height: 60)
                        .background(Color("AACBlue"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                }
            }
            ForEach(0..<textValues.count, id: \.self) { index in
                HStack {
                    
                    HStack {
                        TextField("Enter script here", text: $textValues[index], axis: .vertical).font(.system(size: 24))
                            .padding(10)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 2)
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 30, height: 30)
                            Ellipse()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Image(systemName: "speaker.wave.2.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    speakText(text: textValues[index])
                                }
                        }.padding()
                    }.background(RoundedRectangle(cornerRadius: 10).fill(textValues[index].isEmpty ? .white : Color("AACBlue")))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.black), lineWidth: 1))
                    
                }
            }
            Button(action: {
                self.showScriptText = false
                for (index, text) in self.textValues.enumerated() {
                    categoryTexts["Text\(index + 1)"]?.append(text)
                }
                categoryTexts[currScriptLabel] = textValues
                scriptsViewModel.saveScripts(categoryTexts)
            }) {
                Text("Save")
                    .font(.system(size: 30))
                    .frame(width: 110, height: 60)
                    .background(Color("AACBlue"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2))
            }
            .padding(.top, 4)
        }
        .padding(30)
    }

    // MARK: - Actions

    private func addLine() {
        guard textValues.count < maxLines else { return }
        textValues.append("")
    }

    private func removeLine(at index: Int) {
        guard textValues.count > minLines else { return }
        textValues.remove(at: index)
    }

    private func save() {
        // Clamp just in case and persist
        textValues = Array(textValues.prefix(maxLines))
        if textValues.isEmpty { textValues = [""] }

        categoryTexts[currScriptLabel] = textValues
        scriptsViewModel.saveScripts(categoryTexts)
        showScriptText = false
    }

    private func speakText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }
}

struct ScriptsMakePopUp: View {
    @Binding var visible: Bool //is the popup visible
    @Binding var categories: [String] // Access categories here
    // var vm: TileViewModel
    // @State var currentFolder: Tile
    @State private var labelText: String = ""
    @State private var iconItem: PhotosPickerItem?
    @State private var iconImage: Image?
    @State private var imagePath: String = ""
    @State private var type: String = "Tiles"
    @State private var scriptGenerator = ScriptGenerator()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {visible = false}) { //button to x out of menu to add tile
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
            
            Spacer(minLength: 50)
            
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
                //sets the new icon image for the tile
                .onChange(of: iconItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.iconImage = Image(uiImage: uiImage)
                            }
                            if let savedPath = saveImageToDocumentDirectory2(uiImage) {
                                self.imagePath = savedPath
                            }
                        }
                    }
                }

                Spacer(minLength: 20)
                //sets the label for the tile
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
                if iconImage != nil && !labelText.isEmpty { //doesnt allow you to add until fields are completed
                    Button(action: {
                        Task {
                            visible = false
                            if !categories.contains(labelText) {
                                categories.append(labelText)
                                categoryTexts[labelText] = Array(repeating: "", count: 6)
                                
                                if let data = try? await iconItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data),
                                   let savedPath = saveImageToDocumentDirectory2(uiImage) {
                                    categoryImages[labelText] = savedPath
                                }
                                
                                // Keep track of tile order
                                orderNum = categories.count
                                categoryOrder[orderNum] = labelText
                                orderNum += 1
                                
                                
                                scriptsViewModel.saveScripts(categoryTexts)
                                scriptsViewModel.saveOrder(categoryOrder)
                                scriptsViewModel.saveImages(categoryImages)
                                labelText = ""
                                // vm.addTile(text: labelText, imagePath: imagePath, type: type, parent: self.currentFolder) //adds and saves the new tile
                            }}}) {
                        Text("Add Tile") //button to confirm tile adding
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            .frame(minWidth: 0, maxWidth: 200)
                            .background(Color("AACBlue"))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.black), lineWidth: 2))
                            .cornerRadius(10)
       
                    }
                    .padding()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

struct ScriptsCategoryButton: View {
    @Binding var labelText: String
    var image: Image
    var available: Bool = true
    var imageColor: String = "AACBlack"
    @Binding var showScriptText: Bool // Binding to toggle showScriptText
    
    var body: some View {
        Button(action: {
            showScriptText = true // Toggle showScriptText to true when the button is clicked
            currScriptLabel = labelText
        }) {
            VStack {
                Spacer()
                    .frame(height: 5)
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(.black))
                
                Spacer()
                    .frame(height: 20)
                
                Text(labelText)
                    .font(.system(size: 28))
                    .multilineTextAlignment(.leading)
                
                Spacer()
                    .frame(height: 10)
            }
            .frame(width: 160, height: 160)
            .padding()
            .accentColor(Color.black)
            .cornerRadius(10.0)
            .background(Color("AACGrey"))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
        }
    }
}

struct ScriptsPreview: PreviewProvider {
    static var previews: some View {
        Scripts()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
