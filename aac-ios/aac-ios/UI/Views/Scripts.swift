import SwiftUI
import Foundation
import AVFoundation

struct Scripts: View {
    // Define your categories here
    @State private var categories = ["Health", "Food", "Activities", "TV"]
    
    // State variable to control which view is currently being shown
    @State private var showScriptText = false

    // State variable to hold the new category name
    @State private var newCategoryName = ""

    var body: some View {
        // Create a grid layout with 3 columns
        let columns = Array(repeating: GridItem(.fixed(200), spacing: 60), count: 3)

        VStack {
            HStack {
                TextField("New Category", text: $newCategoryName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    .padding([.top, .leading, .trailing])

                Button(action: {
                    // When the button is clicked, add the new category
                    if !newCategoryName.isEmpty {
                        self.categories.append(newCategoryName)
                        self.newCategoryName = ""
                    }
                }) {
                    Text("Add")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 60) {
                    // Create a button for each category
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            // When the button is clicked, show the ScriptText view
                            self.showScriptText = true
                        }) {
                            Text(category)
                                .frame(width: 200, height: 200)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showScriptText) {
                // This is the view that will be shown when showScriptText is true
                ScriptTextScreen(showScriptText: $showScriptText)
            }
        }
    }
}

struct ScriptTextScreen: View {
    @Binding var showScriptText: Bool
    @Environment(\.presentationMode) var presentationMode

    @State private var textValues: [String] = Array(repeating: "", count: 4)
    let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack {
            ForEach(0..<textValues.count, id: \.self) { index in
                HStack {
                    TextField("Text", text: $textValues[index])
                        .font(.title2)
                        .frame(width: 800, height: 40)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                        .padding([.top, .leading, .trailing])

                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 30, height: 40)
                        .padding(.leading)

                    Image(systemName: "speaker.wave.2.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black) // Change the color to black
                        .onTapGesture {
                            speakText(text: textValues[index])
                        }
                }
            }
        }
        .padding()
        VStack {
            Button(action: {
                self.showScriptText = false
            }) {
                Text("Go Back")
                    .font(.largeTitle) // Increase the font size
                    .frame(width: 200, height: 100) // Set a specific width and height
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    func speakText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }
}
